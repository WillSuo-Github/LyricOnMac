//
//  SongUtility.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/4.
//

import Foundation
import MediaPlayer

class SongUtility {
    // MARK: - Constants
    let kMediaRemotePath = "/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote"

    var MRIsMediaRemoteLoaded = false

    // Define function types using @convention(c) to match C function calling convention
    typealias MRMediaRemoteGetNowPlayingInfoType = @convention(c) (DispatchQueue, @escaping (CFDictionary?) -> Void) -> Void
    typealias MRMediaRemoteGetNowPlayingApplicationIsPlayingType = @convention(c) (DispatchQueue, @escaping (Bool) -> Void) -> Void
    typealias MRMediaRemoteRegisterForNowPlayingNotificationsType = @convention(c) (DispatchQueue) -> Void
    typealias MRMediaRemoteUnregisterForNowPlayingNotificationsType = @convention(c) () -> Void

    // Function Pointers
    var MRMediaRemoteGetNowPlayingInfo: MRMediaRemoteGetNowPlayingInfoType?
    var MRMediaRemoteGetNowPlayingApplicationIsPlaying: MRMediaRemoteGetNowPlayingApplicationIsPlayingType?
    var MRMediaRemoteRegisterForNowPlayingNotifications: MRMediaRemoteRegisterForNowPlayingNotificationsType?
    var MRMediaRemoteUnregisterForNowPlayingNotifications: MRMediaRemoteUnregisterForNowPlayingNotificationsType?
    
    init() {
        loadMediaRemote()
        registerForNowPlayingNotifications()
    }
    
    // Example Usage: Fetch Now Playing Info
    func fetchNowPlayingInfo() {
        guard MRIsMediaRemoteLoaded, let getNowPlayingInfo = MRMediaRemoteGetNowPlayingInfo else {
            print("MediaRemote framework not loaded")
            return
        }
        
        getNowPlayingInfo(DispatchQueue.main) { nowPlayingInfo in
            guard let info = nowPlayingInfo as? [String: Any] else {
                print("No Now Playing Info available")
                return
            }
            
            // Extract title, artist, and album from the Now Playing Info
            if let title = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String {
                print("Title: \(title)")
            }
            
            if let artist = info["kMRMediaRemoteNowPlayingInfoArtist"] as? String {
                print("Artist: \(artist)")
            }
            
            if let album = info["kMRMediaRemoteNowPlayingInfoAlbum"] as? String {
                print("Album: \(album)")
            }
            
            // Extract elapsed time and total duration
            if let elapsedTime = info["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? Double {
                print("Elapsed Time: \(elapsedTime) seconds")
            }
            
            if let duration = info["kMRMediaRemoteNowPlayingInfoDuration"] as? Double {
                print("Duration: \(duration) seconds")
            }
            
            // Check playback rate (1.0 means playing, 0.0 means paused)
            if let playbackRate = info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Double {
                print("Playback Rate: \(playbackRate)")
            }
        }
    }

    
    
    // Load MediaRemote Framework
    private func loadMediaRemote() {
        guard let handle = dlopen(kMediaRemotePath, RTLD_LAZY) else {
            print("Failed to load MediaRemote framework")
            return
        }
        
        MRIsMediaRemoteLoaded = true
        MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(dlsym(handle, "MRMediaRemoteGetNowPlayingInfo"), to: MRMediaRemoteGetNowPlayingInfoType?.self)
        MRMediaRemoteGetNowPlayingApplicationIsPlaying = unsafeBitCast(dlsym(handle, "MRMediaRemoteGetNowPlayingApplicationIsPlaying"), to: MRMediaRemoteGetNowPlayingApplicationIsPlayingType?.self)
        MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(dlsym(handle, "MRMediaRemoteRegisterForNowPlayingNotifications"), to: MRMediaRemoteRegisterForNowPlayingNotificationsType?.self)
        MRMediaRemoteUnregisterForNowPlayingNotifications = unsafeBitCast(dlsym(handle, "MRMediaRemoteUnregisterForNowPlayingNotifications"), to: MRMediaRemoteUnregisterForNowPlayingNotificationsType?.self)
        
        dlclose(handle)
    }
    
    func registerForNowPlayingNotifications() {
        // add notification
        let nc = NotificationCenter.default
        nc.addObserver(forName: .mediaRemoteNowPlayingApplicationPlaybackStateDidChange, object: nil, queue: nil) { [weak self] n in
            self?.nowPlayingInfoDidChange()
        }
        nc.addObserver(forName: .mediaRemoteNowPlayingInfoDidChange, object: nil, queue: nil) { [weak self] n in
            self?.nowPlayingInfoDidChange()
        }
    }
    
    private func unregisterForNowPlayingNotifications() {
        guard MRIsMediaRemoteLoaded, let unregisterForNotifications = MRMediaRemoteUnregisterForNowPlayingNotifications else {
            print("MediaRemote framework not loaded")
            return
        }
        
        unregisterForNotifications()
    }
    
    func nowPlayingInfoDidChange() {
        fetchNowPlayingInfo()  // Fetch the updated Now Playing Info when notification is received
    }
}

private extension Notification.Name {
    static let mediaRemoteNowPlayingInfoDidChange = Notification.Name("kMRMediaRemoteNowPlayingInfoDidChangeNotification")
    static let mediaRemoteNowPlayingApplicationPlaybackStateDidChange = Notification.Name("kMRMediaRemoteNowPlayingApplicationPlaybackStateDidChangeNotification")
}
