//
//  OptionsViewController.swift
//  Plex
//
//  Created by Case Wright on 1/14/16.
//  Copyright © 2016 Case Wright. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {
    
    @IBOutlet weak var windowOpacitySlider: NSSlider!
    @IBOutlet weak var alwaysOnTopBtn: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.windowOpacitySlider.floatValue = NSUserDefaults.standardUserDefaults().floatForKey("windowOpacity")
        self.alwaysOnTopBtn.state = NSUserDefaults.standardUserDefaults().integerForKey("alwaysOnTop")
        // Do view setup here.
    }
    
    @IBAction func windowOpacityValueChanged(sender: NSSlider) {
        NSUserDefaults.standardUserDefaults().setFloat(sender.floatValue, forKey: "windowOpacity")
        Static.windowController.window?.alphaValue = CGFloat(sender.floatValue)
    }
    
    @IBAction func alwaysOnTopBtnPressed(sender: NSButtonCell) {
        if(sender.state == 0) {
            Static.windowController.window?.level =  Int(CGWindowLevelForKey(.NormalWindowLevelKey))
        }
        else {
            Static.windowController.window?.level =  Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(sender.state, forKey: "alwaysOnTop")
    }
}
