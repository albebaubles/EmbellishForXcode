//
//  AppendCommand.swift
//  Embellish
//
//  Created by Al Corbett on 3/24/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//

import AppKit
import AudioToolbox
import Foundation
import XcodeKit

/// append text in pasteboard to the selected lines
class AppendCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(stringData: (NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)!),
			invocation: invocation, completionHandler: completionHandler, operation: .Append)
	}
}

/// run **Embellish.scpt** to capture input text and append to the selected lines
class AppendSelectionCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperationScripted(invocation: invocation, completionHandler: completionHandler, operation: .Append)
	}
}

/// run **Embellish.scpt** to capture input text and append to the selected lines
class ReplaceSelectionCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperationScripted(invocation: invocation, completionHandler: completionHandler, operation: .Replace)
	}
}


/// prepend text in pasteboard to the selected lines
class PrependCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation,
		completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(stringData:
				(NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)!)!,
			invocation: invocation,
			completionHandler: completionHandler, operation: .Prepend)
	}
}

/// run **Embellish.scpt** to capture input text and prepend to the selected lines
class PrependSelectionCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation,
		completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperationScripted(invocation: invocation,
			completionHandler: completionHandler, operation: .Prepend)
	}
}

/// sort the selected lines ascending
class SortCommandAscending: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation,
		completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(stringData:
				(NSPasteboard.general.pasteboardItems?.last?.string(forType: .string)!),
			invocation: invocation,
			completionHandler: completionHandler, operation: .SortAscending)
	}
}

/// sort the selected lines descending
class SortCommandDescending: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation,
		completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(invocation: invocation,
			completionHandler: completionHandler, operation: .SortDescending)
	}
}
