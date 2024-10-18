//
//  MainWindowController.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/18.
//

import Cocoa
import SwiftUI
import SnapKit

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        let contentView = ContentView()
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        window?.contentView?.addSubview(hostingView)
        window?.contentView?.wantsLayer = true
        hostingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-28)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
