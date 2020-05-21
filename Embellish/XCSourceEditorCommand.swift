//
// Created by Al Corbett on 5/5/20.
// Copyright (c) 2020 Albebaubles LLC. All rights reserved.
//

import AppKit
import Foundation
import XcodeKit
import AudioToolbox
import Carbon

extension XCSourceEditorCommand {
	func script() -> NSUserAppleScriptTask? {
		let homeDirPath = FileManager().urls(for: .applicationScriptsDirectory,
			in: .userDomainMask).first!.absoluteString + Bundle.main.bundleIdentifier! + "/Embellish.scpt"

		guard let script = try? NSUserAppleScriptTask(url: URL(fileURLWithPath: homeDirPath)) else {
			print("🚩 unable to load script")
			return nil
		}
		return script
	}

	func performEmbellishOperation(invocation: XCSourceEditorCommandInvocation,
		completionHandler: @escaping (Error?) -> Void,
		operation: EmbellishOperation) {
		defer { completionHandler(nil) }
		guard let first = invocation.buffer.selections.firstObject as? XCSourceTextRange,
			let last = invocation.buffer.selections.lastObject as? XCSourceTextRange,
			first.start.line < last.end.line,
			let newText = NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)! else {
				print("🚩 Embellish: The pasteboard does not contain a string value")
				AudioServicesPlaySystemSound(1519)
				return
		}

		for index in first.start.line...last.end.line {
			guard let line = invocation.buffer.lines[index] as? String else {
				print("🚩 Embellish: the line does not contain a string value")
				AudioServicesPlaySystemSound(1519)
				return
			}

			switch operation {
			case .Append:
				invocation.buffer.lines[index] = line.trim().replacingOccurrences(of: "\n", with: "") + String(describing: newText)
			case .Prepend:
				invocation.buffer.lines[index] = String(describing: newText).trim() + line.trim()
			case .Replace:
				print("replace not yet implemented")
			case .SortAscending:
				self.sort(invocation.buffer.lines,
					in: first.start.line...last.end.line,
					by: self.isLess)
			case .SortDescending:
				self.sort(invocation.buffer.lines,
					in: first.start.line...last.end.line,
					by: self.isMore)
			}
		}
	}

	func performEmbellishOperationScripted(invocation: XCSourceEditorCommandInvocation,
		completionHandler: @escaping (Error?) -> Void,
		operation: EmbellishOperation) {

		let event = operation == .Replace ?   eventDescriptior(functionName: "replace") :  eventDescriptior(functionName: "insert")
		script()?.execute(withAppleEvent: event, completionHandler: { descriptorOut, error in
			if let error = error {
				print(error)
			} else {
				self.performEmbellishOperation(invocation: invocation,
					completionHandler: completionHandler,
					operation: operation)
			}
			completionHandler(nil)
		})
	}

	func eventDescriptior(functionName: String) -> NSAppleEventDescriptor {
		var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
		let target = NSAppleEventDescriptor(
			descriptorType: typeProcessSerialNumber,
			bytes: &psn,
			length: MemoryLayout<ProcessSerialNumber>.size
		)

		let event = NSAppleEventDescriptor(
			eventClass: UInt32(kASAppleScriptSuite),
			eventID: UInt32(kASSubroutineEvent),
			targetDescriptor: target,
			returnID: Int16(kAutoGenerateReturnID),
			transactionID: Int32(kAnyTransactionID)
		)

		let function = NSAppleEventDescriptor(string: functionName)
		event.setParam(function, forKeyword: AEKeyword(keyASSubroutineName))

		return event
	}

	/// sort the range of items in the array by comparator
	func sort(_ input: NSMutableArray, in range: CountableClosedRange<Int>, by comparator: (String, String) -> Bool) {
		guard range.upperBound < input.count, range.lowerBound >= 0 else {
			return
		}

		let lines = input.compactMap { $0 as? String }
		let sorted = Array(lines[range]).sorted(by: comparator)

		for index in range {
			input[index] = sorted[index - range.lowerBound]
		}
	}

	/// less than comparator for sorting
	func isLess(_ first: String, _ second: String) -> Bool {
		return first.trimmingCharacters(in: .whitespaces) < second.trimmingCharacters(in: .whitespaces)
	}

	/// greater than comparator for sorting
	func isMore(_ first: String, _ second: String) -> Bool {
		return !isLess(first, second)
	}
}

enum EmbellishOperation {
	/// It appends text to the selected lines
	case Append
	/// It preprends text to the selected lines
	case Prepend
	/// It sorts the selected lines Ascending
	case Replace
	case SortAscending
/// It sorts the selected lines Descending
	case SortDescending
}


