//
//  FormatCommand.swift
//  Embellish
//
//  Created by Al Corbett on 3/4/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//
//
// Special thanks to the folks to https://github.com/Jintin
// for the SwimAt is copied directly from them

import Foundation
import XcodeKit

class FormatCommand: NSObject, XCSourceEditorCommand {

	let supportUTIs = [
		"com.apple.dt.playground",
		"com.apple.dt.playgroundpage",
		"public.swift-source"
	]

	func perform(with invocation: XCSourceEditorCommandInvocation,
		completionHandler: @escaping (Error?) -> Void) {

		guard supportUTIs.contains(invocation.buffer.contentUTI) else {
			completionHandler(nil)
			return
		}

		if invocation.buffer.usesTabsForIndentation {
			Indent.char = "\t"
		} else {
			Indent.char = String(repeating: String.space(), count: invocation.buffer.indentationWidth)
		}

		let parser = SwimAtSwiftParser(string: invocation.buffer.completeBuffer)
		do {
			let lines = invocation.buffer.lines
			let newLines = try parser.format().components(separatedBy: "\n")
			let selections = invocation.buffer.selections
			var hasSelection = false

			for outerLineCount in 0 ..< selections.count {
				if let selection = selections[outerLineCount] as? XCSourceTextRange, selection.start != selection.end {
					hasSelection = true
					for innerLineCount in selection.start.line...selection.end.line {
						updateLine(lines: lines, newLines: newLines, index: innerLineCount)
					}
				}
			}
			if !hasSelection {
				for outerLineCount in 0 ..< lines.count {
					updateLine(lines: lines, newLines: newLines, index: outerLineCount)
				}
			}
			completionHandler(nil)
		} catch {
			completionHandler(error as NSError)
		}
	}

	func updateLine(lines: NSMutableArray, newLines: [String], index: Int) {
		guard index < newLines.count, index < lines.count else {
			return
		}
		if let line = lines[index] as? String {
			let newLine = newLines[index] + "\n"
			if newLine != line {
				lines[index] = newLine
			}
		}
	}

}

extension XCSourceTextPosition: Equatable {
	public static func == (left: XCSourceTextPosition, right: XCSourceTextPosition) -> Bool {
		return left.column == right.column && left.line == right.line
	}

}

extension String {
	public static func space() -> String {
		return " "
	}
}

extension Character {
	public static func space() -> Character {
		return " "
	}
}
