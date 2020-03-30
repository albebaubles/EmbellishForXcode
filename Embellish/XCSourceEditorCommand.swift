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
			in: .userDomainMask).first!.absoluteString +
			Bundle.main.bundleIdentifier! + "/Embellish.scpt"

		guard let script = try? NSUserAppleScriptTask(url: URL(fileURLWithPath: homeDirPath)) else {
			return nil
		}
		print("🚩 Embellish: get script")
		return script
	}

	func performEmbellishOperation(invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void, operation: EmbellishOperation, scripted: Bool) {
		if scripted {
			script()?.execute(completionHandler: { error in
				if let error = error {
					print(error)
				} else {
					guard let first = invocation.buffer.selections.firstObject as? XCSourceTextRange,
						let last = invocation.buffer.selections.lastObject as? XCSourceTextRange,
						first.start.line < last.end.line,
						let newText = NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)! else {
							print("🚩 Embellish: The pasteboard does not contain a string value")
							AudioServicesPlaySystemSound(1519)
							return
					}

					for index in first.start.line...last.end.line - 1 {
						guard let line = invocation.buffer.lines[index] as? String else {
							print("🚩 Embellish: the line does not contain a string value")
							AudioServicesPlaySystemSound(1519)
							return
						}

						switch operation {
						case .Append:
							invocation.buffer.lines[index] = line.trim() + String(describing: newText)
						case .Prepend:
							invocation.buffer.lines[index] = String(describing: newText) + line.trim()
						case .Sort:
							self.sort(invocation.buffer.lines, in: first.start.line...last.end.line - 1, by: self.isLessWhenTrimmed)
						}
					}
					completionHandler(nil)
				}
			})
		} else {
			defer { completionHandler(nil) }
			guard let first = invocation.buffer.selections.firstObject as? XCSourceTextRange,
				let last = invocation.buffer.selections.lastObject as? XCSourceTextRange,
				first.start.line < last.end.line,
				let newText = NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)! else {
					print("🚩 Embellish: The pasteboard does not contain a string value")
					AudioServicesPlaySystemSound(1519)
					return
			}

			for index in first.start.line...last.end.line - 1 {
				guard let line = invocation.buffer.lines[index] as? String else {
					print("🚩 Embellish: the line does not contain a string value")
					AudioServicesPlaySystemSound(1519)
					return
				}

				switch operation {
				case .Append:
					invocation.buffer.lines[index] = line.trim() + String(describing: newText)
				case .Prepend:
					invocation.buffer.lines[index] = String(describing: newText) + line.trim()
				case .Sort:
					self.sort(invocation.buffer.lines,
										in: first.start.line...last.end.line - 1,
										by: self.isLessWhenTrimmed)
				}
			}
		}
	}

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

	func isLessWhenTrimmed(_ first: String, _ second: String) -> Bool {
		return first.trimmingCharacters(in: .whitespaces) < second.trimmingCharacters(in: .whitespaces)
	}
}

enum EmbellishOperation {
	case Append
	case Prepend
	case Sort
}


