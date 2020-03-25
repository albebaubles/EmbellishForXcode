//
//  SourceEditorCommand.swift
//  Embellish
//
//  Created by Al Corbett on 3/4/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//

import Foundation
import XcodeKit

class SortCommand: NSObject, XCSourceEditorCommand {
    
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
		defer { completionHandler(nil) }

		guard let first = invocation.buffer.selections.firstObject as? XCSourceTextRange,
			let last = invocation.buffer.selections.lastObject as? XCSourceTextRange else { return }
		guard first.start.line < last.end.line else { return }

		sort(invocation.buffer.lines, in: first.start.line...last.end.line, by: isLessWhenTrimmed)
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
