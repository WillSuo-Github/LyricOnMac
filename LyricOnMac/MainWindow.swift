//
//  MainWindow.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/22.
//

import Cocoa

class MainWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        titlebarAppearsTransparent = true
        styleMask = [.borderless, .resizable]
        isOpaque = false
        backgroundColor = .clear
        
        setupContentView()
    }
    
    override var contentView: NSView? {
        didSet {
            setupContentView()
        }
    }
    
    func setupContentView() {
        contentView?.wantsLayer = true
        contentView?.layer?.backgroundColor = NSColor.clear.cgColor
        contentView?.layer?.frame = contentView?.frame ?? .zero
        contentView?.layer?.cornerRadius = 6
        contentView?.layer?.masksToBounds = true
    }
}
