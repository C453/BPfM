//
//  view.swift
//  BPfM
//
//  Created by Case Wright on 1/13/16.
//  Copyright © 2016 Case Wright. All rights reserved.
//

import Cocoa
import WebKit

class wview: WebView, WebUIDelegate, WebFrameLoadDelegate, WebEditingDelegate, NSWindowDelegate {
    
    var lastTrackingArea: NSTrackingArea!
    var didLoadLocalData: Bool!
    var mouseOverScrollBar: Bool = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.didLoadLocalData = false
        self.UIDelegate = self
        self.editingDelegate = self
        self.frameLoadDelegate = self
        if(NSUserDefaults.standardUserDefaults().objectForKey("localData") == nil) {
            NSUserDefaults.standardUserDefaults().setObject("{\"serverUpdateDismissedVersion\": \"unknown\", \"hasSeenHolidayTooltip\": true}", forKey: "localData")
        }
        
        self.preferences.privateBrowsingEnabled = false
        self.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: "http://app.plex.tv/web/app")!))
        
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        let trackingArea = NSTrackingArea(rect: dirtyRect, options: [NSTrackingAreaOptions.ActiveAlways, NSTrackingAreaOptions.MouseMoved, NSTrackingAreaOptions.MouseMoved, NSTrackingAreaOptions.EnabledDuringMouseDrag], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
        
        if(lastTrackingArea != nil) {
            self.removeTrackingArea(lastTrackingArea)
        }
        
        lastTrackingArea = trackingArea
        // Drawing code here.
    }
    
    //hide stoplight buttons on mouse exit
    override func mouseEntered(theEvent: NSEvent) {
        self.window?.setTitleBarHidden(false)
    }
    
    override func mouseExited(theEvent: NSEvent) {
        self.window?.setTitleBarHidden(true)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.window?.setTitleBarHidden(true)
    }
    
    //disable right-click
    func webView(sender: WebView!, contextMenuItemsForElement element: [NSObject : AnyObject]!, defaultMenuItems: [AnyObject]!) -> [AnyObject]! {
        return nil
    }
    
    //remove items from login, other annoyances
    func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        self.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName(\"container-fluid header blog\")[0].innerHTML = \"\";document.getElementsByClassName(\"container-fluid dark footer\")[0].innerHTML = \"\";document.getElementsByClassName(\"quest\")[0].innerHTML = \"\";document.getElementsByClassName(\"hidden-print\")[0].innerHTML = \"\";")
        
        if(!didLoadLocalData) {
            loadLocalData()
            didLoadLocalData = true
        }
    }
    
    func webView(sender: WebView!, mouseDidMoveOverElement elementInformation: [NSObject : AnyObject]!, modifierFlags: Int)
    {
        if(Bool.init(elementInformation["WebElementIsInScrollBar"] as! NSNumber)) {
            mouseOverScrollBar = true
            return
        }
        else if(elementInformation["WebElementDOMNode"] is DOMHTMLElement) {
            let element = elementInformation["WebElementDOMNode"] as! DOMHTMLElement
            
            mouseOverScrollBar = element.className.containsString("slider")
            return
        }
        
        mouseOverScrollBar = false
    }
    
    //disable dragging
    func webView(webView: WebView!, dragSourceActionMaskForPoint point: NSPoint) -> Int {
        return Int(WebDragSourceAction.None.rawValue)
    }
    
    func webView(webView: WebView!, dragDestinationActionMaskForDraggingInfo draggingInfo: NSDraggingInfo!) -> Int {
        return Int(WebDragDestinationAction.None.rawValue);
    }
    
    override func webView(webView: WebView!, shouldChangeSelectedDOMRange currentRange: DOMRange!, toDOMRange proposedRange: DOMRange!, affinity selectionAffinity: NSSelectionAffinity, stillSelecting flag: Bool) -> Bool {
        return proposedRange.startContainer.isContentEditable
    }
    
    override var mouseDownCanMoveWindow: Bool {
        return true
    }

    func loadLocalData() {
        let localData = NSUserDefaults.standardUserDefaults().objectForKey("localData") as! String
        stringByEvaluatingJavaScriptFromString("localStorage.setItem('settingsv2', '\(localData)');")
    }
}

extension WebView {
    func saveLocalData() {
        let localData = stringByEvaluatingJavaScriptFromString("localStorage.getItem('settingsv2');")
        NSUserDefaults.standardUserDefaults().setObject(localData, forKey: "localData")
    }
}
