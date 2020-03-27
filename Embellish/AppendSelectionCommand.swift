//
//  AppendSelectionCommand.swift
//  Embellish
//
//  Created by Al Corbett on 3/26/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//


import AppKit
import Foundation
import XcodeKit
import AudioToolbox
import Carbon

class AppendSelectionCommand: NSObject, XCSourceEditorCommand {

	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {

		//		let filePath = Bundle.main.path(forResource: "Embellish", ofType: "scpt")
		guard let script = try? NSUserAppleScriptTask(url: URL(fileURLWithPath:  "/Users/acorbett/Library/Application Scripts/com.albebaubles.EmbellishForXcode.Embellish/Embellish.scpt")) else {
			return
		}

		script.execute(completionHandler:{ error in
			if let error = error {
				print(error)
			} else {
				guard let first = invocation.buffer.selections.firstObject as? XCSourceTextRange,
					let last = invocation.buffer.selections.lastObject as? XCSourceTextRange,
					first.start.line < last.end.line,
					let prependText = NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)! else {
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
					invocation.buffer.lines[index] = line.trim() + String(describing: prependText) 
				}
				completionHandler(nil)
			}
		})
	}
}
