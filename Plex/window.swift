//
//  window.swift
//  Plex
//
//  Created by Case Wright on 1/13/16.
//  Copyright © 2016 Case Wright. All rights reserved.
//

import Cocoa

class window: NSWindow {
    
    var initialLocation: NSPoint!
    
    override var canBecomeKeyWindow: Bool {
        return true
    }
    
    override var canBecomeMainWindow: Bool {
        return true
    }
    
    override func sendEvent(theEvent: NSEvent) {
        if(theEvent.type == NSEventType.LeftMouseDown) {
            self.mouseDown(theEvent)
        }
        else if(theEvent.type == NSEventType.LeftMouseDragged) {
            self.mouseDragged(theEvent)
        }
        super.sendEvent(theEvent)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.initialLocation = theEvent.locationInWindow
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        var currentLocation: NSPoint
        var newOrigin: NSPoint
        var screenFrame: NSRect = NSScreen.mainScreen()!.frame
        var windowFrame: NSRect = self.frame
        currentLocation = NSEvent.mouseLocation()
        newOrigin = NSPoint(x: currentLocation.x - self.initialLocation.x, y: currentLocation.y - self.initialLocation.y)
        
        // Don't let window get dragged up under the menu bar
        if (newOrigin.y + windowFrame.size.height) > (screenFrame.origin.y + screenFrame.size.height) {
            newOrigin.y = screenFrame.origin.y + (screenFrame.size.height - windowFrame.size.height)
        }
        //go ahead and move the window to the new location
        self.setFrameOrigin(newOrigin)

    }
}
