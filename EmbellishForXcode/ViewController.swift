//
//  ViewController.swift
//  EmbellishForXcode
//
//  Created by Al Corbett on 3/4/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

				let filePath = Bundle.main.path(forResource: "Embellish", ofType: "scpt")
//		FileManager().copyItem(at: <#T##URL#>, to: <#T##URL#>)
//		guard let script = try? NSUserAppleScriptTask(url: URL(fileURLWithPath:  "/Users/acorbett/Library/Application Scripts/com.albebaubles.EmbellishForXcode.Embellish/Embellish.scpt")) else {
//			return
//		}
}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

