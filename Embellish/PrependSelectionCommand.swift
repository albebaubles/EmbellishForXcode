//
//  PrependSelectionCommand.swift
//  Embellish
//
//  Created by Al Corbett on 3/25/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//

import AppKit
import AudioToolbox
import Carbon
import Foundation
import XcodeKit

class PrependSelectionCommand: NSObject, XCSourceEditorCommand {

	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		let homeDirPath = "/Users/" + NSUserName() + "/Library/Application Scripts/com.albebaubles.EmbellishForXcode.Embellish/Embellish.scpt"

		guard let script = try? NSUserAppleScriptTask(url: URL(fileURLWithPath: homeDirPath)) else {
			return
		}

		script.execute(completionHandler: { error in
			if let error = error {
				print(error)
			} else {
				let first = invocation.buffer.selections.firstObject as? XCSourceTextRange
				let last = invocation.buffer.selections.lastObject as? XCSourceTextRange
				guard let prependText = NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)! else {
					print("Embellish: The pasteboard does not contain a string value")
					AudioServicesPlaySystemSound(1519)
					return
				}
				for index in first!.start.line...last!.end.line - 1 {
					guard let line = invocation.buffer.lines[index] as? String else {
						print("Embellish: the line does not contain a string value")
						AudioServicesPlaySystemSound(1519)
						return
					}
					invocation.buffer.lines[index] = String(describing: prependText) + line.trim()
				}
				completionHandler(nil)

			}
		})
	}
}
