//
//  ViewController.swift
//  EmbellishForXcode
//
//  Created by Al Corbett on 3/4/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	@IBOutlet var scriptText: NSTextView!

	override func viewDidLoad() {
		super.viewDidLoad()
		scriptText.setSelectedRange(
			.init(location: 0, length: scriptText.string.count))
	}


	func shell(_ command: String) -> String {
		let pipe = Pipe()
		let task = Process()

		task.arguments = ["-c", command]
		task.launchPath = "/bin/bash"
		task.standardOutput = pipe
		task.launch()

		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)!

		return output
	}

	@IBAction func copyScript(_ sender: Any) {
		_ = shell("open -a Terminal")
	}

	@IBAction func showPreferences(_ sender: Any) {
		NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Extensions.prefPane"))
	}
}

