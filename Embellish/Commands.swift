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

/// append text in pasteboard to the selected lines
class AppendCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(invocation: invocation, completionHandler: completionHandler, operation: .Append, scripted: false)
	}
}

/// run **Embellish.scpt** to capture input text and append to the selected lines
class AppendSelectionCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(invocation: invocation, completionHandler: completionHandler, operation: .Append, scripted: true)
	}
}

/// prepend text in pasteboard to the selected lines
class PrependCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(invocation: invocation, completionHandler: completionHandler, operation: .Prepend, scripted: false)
	}
}

/// run **Embellish.scpt** to capture input text and prepend to the selected lines
class PrependSelectionCommand: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(invocation: invocation, completionHandler: completionHandler, operation: .Prepend, scripted: true)
	}
}

/// sort the selected lines ascending collation
class SortCommandAscending: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(invocation: invocation, completionHandler: completionHandler, operation: .SortAscending, scripted: false)
	}
}

/// sort the selected lines descending collation
class SortCommandDescending: NSObject, XCSourceEditorCommand {
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) -> Void {
		performEmbellishOperation(invocation: invocation, completionHandler: completionHandler, operation: .SortDescending, scripted: false)
	}
}
