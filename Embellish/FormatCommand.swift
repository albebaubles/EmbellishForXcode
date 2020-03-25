//
//  FormatCommand.swift
//  Embellish
//
//  Created by Al Corbett on 3/4/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//

import Foundation
import XcodeKit

class FormatCommand:  NSObject, XCSourceEditorCommand {

	let supportUTIs = [
		"com.apple.dt.playground",
		"com.apple.dt.playgroundpage",
		"public.swift-source"
	]

	func perform(with invocation: XCSourceEditorCommandInvocation,
							 completionHandler: @escaping (Error?) -> Void) {

		let uti = invocation.buffer.contentUTI

		guard supportUTIs.contains(uti) else {
			completionHandler(nil)
			return
		}

		if invocation.buffer.usesTabsForIndentation {
			Indent.char = "\t"
		} else {
			Indent.char = String(repeating: " ", count: invocation.buffer.indentationWidth)
		}

		let parser = SwiftParser(string: invocation.buffer.completeBuffer)
		do {
			let lines = invocation.buffer.lines
			let newLines = try parser.format().components(separatedBy: "\n")
			let selections = invocation.buffer.selections
			var hasSelection = false

			for i in 0 ..< selections.count {
				if let selection = selections[i] as? XCSourceTextRange, selection.start != selection.end {
					hasSelection = true
					for j in selection.start.line...selection.end.line {
						updateLine(lines: lines, newLines: newLines, index: j)
					}
				}
			}
			if !hasSelection {
				for i in 0 ..< lines.count {
					updateLine(lines: lines, newLines: newLines, index: i)
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

	public static func == (lhs: XCSourceTextPosition, rhs: XCSourceTextPosition) -> Bool {
		return lhs.column == rhs.column && lhs.line == rhs.line
	}

}
