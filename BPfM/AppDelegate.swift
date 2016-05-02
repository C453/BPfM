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
    @IBOutlet weak var opacityMenuItem: NSMenuItem!
    @IBOutlet weak var opacityMenuView: NSView!
    @IBOutlet weak var opacitySlider: NSSlider!
    @IBOutlet weak var alwaysOnTopMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        opacityMenuItem.view = opacityMenuView
        
        //Set values on first run
        if(NSUserDefaults.standardUserDefaults().objectForKey("windowOpacity") == nil) {
            NSUserDefaults.standardUserDefaults().setFloat(1, forKey: "windowOpacity")
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("alwaysOnTop") == nil) {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "alwaysOnTop")
        }
        
        alwaysOnTopMenuItem.state = NSUserDefaults.standardUserDefaults().integerForKey("alwaysOnTop")
        opacitySlider.floatValue = NSUserDefaults.standardUserDefaults().floatForKey("windowOpacity")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func opacitySliderValueChanged(sender: NSSlider) {
        NSUserDefaults.standardUserDefaults().setFloat(sender.floatValue, forKey: "windowOpacity")
        Static.windowController.window?.alphaValue = CGFloat(sender.floatValue)
    }
    @IBAction func alwaysOnTopMenuItemPressed(sender: NSMenuItem) {
        if(sender.state == 1) {
            sender.state = 0
            Static.windowController.window?.level =  Int(CGWindowLevelForKey(.NormalWindowLevelKey))
        }
        else {
            sender.state = 1
            Static.windowController.window?.level =  Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(sender.state, forKey: "alwaysOnTop")
    }
    
    @IBAction func setAutoAspectRatio(sender: NSMenuItem) {
        
        if(sender.state == NSOffState) {
        
            let vidWidth = Int((Static.windowController.window?.contentView as! wview).stringByEvaluatingJavaScriptFromString("document.getElementsByClassName(\"html-video\")[0].videoWidth"))
        
            let vidHeight = Int((Static.windowController.window?.contentView as! wview).stringByEvaluatingJavaScriptFromString("document.getElementsByClassName(\"html-video\")[0].videoHeight"))
        
            guard vidHeight > 0 else {
                return
            }
        
            resize(CGFloat(vidWidth!) / CGFloat(vidHeight!))
        
            sender.state = NSOnState
        } else {
            sender.state = NSOffState
            Static.windowController.aspectRatio = 0
        }
    }
    
    func resize(ratio: CGFloat) {
        let window = Static.windowController.window!
        let height = window.frame.size.height
        let width = window.frame.size.height * ratio
        
        Static.windowController.aspectRatio = ratio
        
        window.setFrame(NSMakeRect(window.frame.origin.x, window.frame.origin.y, width, height), display: true, animate: true)
    }
}

