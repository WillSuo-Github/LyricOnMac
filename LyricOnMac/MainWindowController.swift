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

    @IBOutlet weak var container: NSView!
    
    private var trackingArea: NSTrackingArea?
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var stickButton = {
        let result = NSButton(image: NSImage(systemSymbolName: "pin.slash.fill", accessibilityDescription: nil)!, target: self, action: #selector(stickButtonDidClick))
        result.alternateImage = NSImage(systemSymbolName: "pin.fill", accessibilityDescription: nil)
        result.isBordered = false
        result.imagePosition = .imageOnly
        result.imageScaling = .scaleProportionallyDown
        result.setButtonType(.toggle)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
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
        container.isHidden = true
        
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
        container.addSubview(stickButton)
        stickButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
        }
    }
    
    private func mouseDidEnter() {
        container.isHidden = false
    }
    
    private func mouseDidExit() {
        container.isHidden = true
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
