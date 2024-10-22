//
//  MainWindowController.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/18.
//

import Cocoa
import SwiftUI
import SnapKit
import Combine

class MainWindowController: NSWindowController {

    @IBOutlet weak var effectView: NSVisualEffectView!
    
    private var trackingArea: NSTrackingArea?
    private var cancellable = Set<AnyCancellable>()
    
    override func windowDidLoad() {
        super.windowDidLoad()

        setupUI()
        setupMouseEvent()
    }
}

// MARK: - UI
extension MainWindowController {
    private func setupUI() {
        window?.backgroundColor = .clear
        effectView.isHidden = true
        
        setupContentView()
        setupStickButton()
    }
    
    private func setupContentView() {
        let contentView = ContentView()
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        window?.contentView?.addSubview(hostingView)
        hostingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupStickButton() {
        guard let window = window else { return }
        
        let stickButton = NSButton(image: NSImage(systemSymbolName: "pin.slash.fill", accessibilityDescription: nil)!, target: self, action: #selector(stickButtonDidClick))
        stickButton.alternateImage = NSImage(systemSymbolName: "pin.fill", accessibilityDescription: nil)
        stickButton.isBordered = false
        stickButton.imagePosition = .imageOnly
        stickButton.imageScaling = .scaleProportionallyDown
        stickButton.setButtonType(.toggle)
        stickButton.translatesAutoresizingMaskIntoConstraints = false
        window.contentView?.addSubview(stickButton)
        stickButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
        }
    }
    
    private func mouseDidEnter() {
        effectView.isHidden = false
    }
    
    private func mouseDidExit() {
        effectView.isHidden = true
    }
}

// MARK: - Mouse Event
extension MainWindowController {
    private func setupMouseEvent() {
        guard let mainView = window?.contentView as? MainView else { return }
        
        mainView.mouseEnteredSubject
            .sink { [weak self] event in
                self?.mouseDidEnter()
            }
            .store(in: &cancellable)
        
        mainView.mouseExitedSubject
            .sink { [weak self] event in
                self?.mouseDidExit()
            }
            .store(in: &cancellable)
    }
}

// MARK: - Action
extension MainWindowController {
    @objc private func stickButtonDidClick() {
        window?.level = window?.level == .floating ? .normal : .floating
    }
}
