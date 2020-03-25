//
//  AppendCommand.swift
//  Embellish
//
//  Created by Al Corbett on 3/24/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//

import AppKit
import Foundation
import XcodeKit
import AudioToolbox

class AppendCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		defer { completionHandler(nil) }

		guard let first = invocation.buffer.selections.firstObject as? XCSourceTextRange,
			let last = invocation.buffer.selections.lastObject as? XCSourceTextRange,
			first.start.line < last.end.line,
			let appendText = NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)! else {
				print("Embellish: The pasteboard does not contain a string value")
				AudioServicesPlaySystemSound(1519)
				return
		}

		for index in first.start.line...last.end.line {
			guard let line = invocation.buffer.lines[index] as? String else {
				print("Embellish: the line does not contain a string value")
				AudioServicesPlaySystemSound(1519)
				return
			}
			invocation.buffer.lines[index] = line.trim() + String(describing: appendText)
		}
	}
}
