//
//  AppDelegate.swift
//  Netflix
//
//  Created by Case Wright on 11/25/15.
//  Copyright © 2015 Case Wright. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        //Set values on first run
        if(NSUserDefaults.standardUserDefaults().objectForKey("windowOpacity") == nil) {
            NSUserDefaults.standardUserDefaults().setFloat(1, forKey: "windowOpacity")
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("alwaysOnTop") == nil) {
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "alwaysOnTop")
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}

