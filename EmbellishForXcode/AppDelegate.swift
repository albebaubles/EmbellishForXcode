//
//  AppDelegate.swift
//  EmbellishForXcode
//
//  Created by Al Corbett on 3/4/20.
//  Copyright © 2020 Albebaubles LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		let def = UserDefaults.init(suiteName: "com.apple.osascript")
		def?.synchronize()
//		let def = UserDefaults.standard

//		let x =  UserDefaults.init(suiteName: "Embellish")!.array(forKey: "insert")!
		//print("🚩" + x as String)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

