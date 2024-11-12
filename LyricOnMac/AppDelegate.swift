//
//  AppDelegate.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/18.
//

import Cocoa
import Sparkle

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var mainWindowController: MainWindowController = MainWindowController(windowNibName: "MainWindowController")
    private var updater: SPUUpdater = SPUUpdater(hostBundle: Bundle.main, applicationBundle: Bundle.main, userDriver: UpdateDriver(), delegate: UpdateDelegate())

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
