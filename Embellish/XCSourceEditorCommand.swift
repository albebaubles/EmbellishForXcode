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
	var scriptPath: URL? {
		return try? FileManager.default.url(
			for: .applicationScriptsDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true
		)
	}

	func fileScriptPath(filename: String) -> URL? {
		return scriptPath?
			.appendingPathComponent(filename)
			.appendingPathExtension("scpt")
	}

	func script() -> NSUserAppleScriptTask? {

		NSLog("🚩 before load script")
		guard let script = try? NSUserAppleScriptTask(url: fileScriptPath(filename: "Embellish")!) else {
			// since this is an add-in, do not raise an error
			NSLog("🚩 unable to load script")
			return nil
		}
		return script
	}

	func performEmbellishOperation(stringData: String? = "", invocation: XCSourceEditorCommandInvocation,
		completionHandler: @escaping (Error?) -> Void,
		operation: EmbellishOperation) {
		defer { completionHandler(nil) }
		guard let first = invocation.buffer.selections.firstObject as? XCSourceTextRange,
			let last = invocation.buffer.selections.lastObject as? XCSourceTextRange,
			first.start.line < last.end.line else {
				// since this is an add-in, do not raise an error
				print("🚩 Embellish: The selection does not contain a string value")
				return
		}

		for index in first.start.line...last.end.line {
			guard let line = invocation.buffer.lines[index] as? String else {
				// since this is an add-in, do not raise an error
				print("🚩 Embellish: the line does not contain a string value")
				return
			}

			switch operation {
			case .Append:
				invocation.buffer.lines[index] = line.trim().replacingOccurrences(of: "\n", with: "") + String(describing: stringData!)
			case .Prepend:
				invocation.buffer.lines[index] = String(describing: stringData!).trim() + line.trim()
			case .Replace:
				let oldText = stringData!.split(separator: "🔆")[0]
				let newText = stringData!.split(separator: "🔆")[1]
				invocation.buffer.lines[index] = (invocation.buffer.lines[index] as! String).replacingOccurrences(of: oldText, with: newText)
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

		guard let event = operation == .Replace ? eventDescriptior(functionName: "replace"):
			eventDescriptior(functionName: "insert") else { return }
		script()?.execute(withAppleEvent: event, completionHandler: { descriptorOut, error in
			if let error = error {
				print(error)
			} else {
				self.performEmbellishOperation(stringData: descriptorOut?.stringValue, invocation: invocation,
					completionHandler: completionHandler,
					operation: operation)
			}
			completionHandler(nil)
		})
	}

	func eventDescriptior(functionName: String) -> NSAppleEventDescriptor? {
		var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
		guard let target = NSAppleEventDescriptor(
			descriptorType: typeProcessSerialNumber,
			bytes: &psn,
			length: MemoryLayout<ProcessSerialNumber>.size
		) else { return nil }

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
	/// appends text to the selected lines
	case Append
	/// preprends text to the selected lines
	case Prepend
	/// sorts the selected lines Ascending
	case Replace
	case SortAscending
	/// sorts the selected lines Descending
	case SortDescending
}


