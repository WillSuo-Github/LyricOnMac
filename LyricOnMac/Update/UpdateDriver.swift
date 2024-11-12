//
//  UpdateDriver.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/11/12.
//

import Foundation
import Sparkle

final class UpdateDriver: NSObject {
    
}

extension UpdateDriver: SPUUserDriver {
    func show(_ request: SPUUpdatePermissionRequest) async -> SUUpdatePermissionResponse {
        return .init(automaticUpdateChecks: true, automaticUpdateDownloading: true, sendSystemProfile: true)
    }
    
    func showUserInitiatedUpdateCheck(cancellation: @escaping () -> Void) {
            
    }
    
    func showUpdateFound(with appcastItem: SUAppcastItem, state: SPUUserUpdateState) async -> SPUUserUpdateChoice {
        return .install
    }
    
    func showUpdateReleaseNotes(with downloadData: SPUDownloadData) {
        
    }
    
    func showUpdateReleaseNotesFailedToDownloadWithError(_ error: any Error) {
        
    }
    
    func showUpdateNotFoundWithError(_ error: any Error, acknowledgement: @escaping () -> Void) {
        
    }
    
    func showUpdaterError(_ error: any Error, acknowledgement: @escaping () -> Void) {
        
    }
    
    func showDownloadInitiated(cancellation: @escaping () -> Void) {
        
    }
    
    func showDownloadDidReceiveExpectedContentLength(_ expectedContentLength: UInt64) {
        
    }
    
    func showDownloadDidReceiveData(ofLength length: UInt64) {
        
    }
    
    func showDownloadDidStartExtractingUpdate() {
        
    }
    
    func showExtractionReceivedProgress(_ progress: Double) {
        
    }
    
    func showReadyToInstallAndRelaunch() async -> SPUUserUpdateChoice {
        return .install
    }
    
    func showInstallingUpdate(withApplicationTerminated applicationTerminated: Bool, retryTerminatingApplication: @escaping () -> Void) {
        
    }
    
    func showUpdateInstalledAndRelaunched(_ relaunched: Bool, acknowledgement: @escaping () -> Void) {
        
    }
    
    func showUpdateInFocus() {
        
    }
    
    func dismissUpdateInstallation() {
        
    }
}
