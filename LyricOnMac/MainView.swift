//
//  MainView.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/22.
//

import Cocoa
import Combine

class MainView: NSView {
    var mouseEnteredSubject = PassthroughSubject<NSEvent, Never>()
    var mouseExitedSubject = PassthroughSubject<NSEvent, Never>()
    
    private var trackingArea: NSTrackingArea?

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        
        mouseEnteredSubject.send(event)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        
        mouseExitedSubject.send(event)
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
        }
        
        let options: NSTrackingArea.Options = [.activeAlways, .mouseEnteredAndExited]
        trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        if let trackingArea = trackingArea {
            addTrackingArea(trackingArea)
        }
    }
}
