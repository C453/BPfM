//
//  WindowController.swift
//  Netflix
//
//  Created by Case Wright on 11/25/15.
//  Copyright © 2015 Case Wright. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        self.window?.titleVisibility = NSWindowTitleVisibility.Hidden
        self.window?.titlebarAppearsTransparent = true
        self.window?.movableByWindowBackground = true
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        self.window?.setTitleBarHidden(false)
    }
    
    override func mouseExited(theEvent: NSEvent) {
        self.window?.setTitleBarHidden(true)
    }
}

extension NSWindow {
    
    func setTitleBarHidden(hidden: Bool, animated: Bool = true) {
        
        let buttonSuperView = standardWindowButtonSuperView()
        if buttonSuperView == nil {
            return
        }
        let view = buttonSuperView!
        if hidden {
            if view.alphaValue > 0.1 {
                if !animated {
                    view.alphaValue = 0
                    return
                }
                view.animator().alphaValue = 0
            }
            return
        }
        
        if view.alphaValue < 1 {
            if !animated {
                view.alphaValue = 1
                return
            }
            view.animator().alphaValue = 1
        }
    }
    
    func standardWindowButtonSuperView() -> NSView? {
        return standardWindowButton(NSWindowButton.ZoomButton)?.superview
    }
}
