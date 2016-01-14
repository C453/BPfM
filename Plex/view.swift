//
//  view.swift
//  PLEX
//
//  Created by Case Wright on 1/13/16.
//  Copyright © 2016 Case Wright. All rights reserved.
//

import Cocoa
import WebKit

class wview: WebView, WebUIDelegate, WebFrameLoadDelegate, WebEditingDelegate {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.UIDelegate = self
        self.editingDelegate = self
        self.frameLoadDelegate = self
        
        self.preferences.privateBrowsingEnabled = false
        self.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: "http://app.plex.tv/web/app")!))
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        let trackingArea = NSTrackingArea(rect: dirtyRect, options: [NSTrackingAreaOptions.ActiveAlways, NSTrackingAreaOptions.MouseMoved, NSTrackingAreaOptions.MouseMoved, NSTrackingAreaOptions.EnabledDuringMouseDrag], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)

        // Drawing code here.
    }
    
    //hide stoplight buttons on mouse exit
    override func mouseEntered(theEvent: NSEvent) {
        self.window?.setTitleBarHidden(false)
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
}
