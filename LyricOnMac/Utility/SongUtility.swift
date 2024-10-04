//
//  SongUtility.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/4.
//

import Foundation
import MediaPlayer

// NowPlayingInfo struct to encapsulate the now playing information
struct NowPlayingInfo {
    let title: String?
    let artist: String?
    let album: String?
    let elapsedTime: Double?
    let duration: Double?
    let playbackRate: Double?
}

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
    }

    // Infinite async sequence to fetch Now Playing Info
    @MainActor
    func nowPlayingInfoSequence() -> AsyncStream<NowPlayingInfo?> {
        return AsyncStream { continuation in
            Task {
                while !Task.isCancelled {
                    let nowPlayingInfo = await fetchNowPlayingInfo()
                    continuation.yield(nowPlayingInfo)
                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
                }
                continuation.finish()
            }
        }
    }

    // Fetch Now Playing Info using async/await
    private func fetchNowPlayingInfo() async -> NowPlayingInfo? {
        guard MRIsMediaRemoteLoaded, let getNowPlayingInfo = MRMediaRemoteGetNowPlayingInfo else {
            print("MediaRemote framework not loaded")
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            getNowPlayingInfo(DispatchQueue.main) { nowPlayingInfo in
                guard let info = nowPlayingInfo as? [String: Any] else {
                    print("No Now Playing Info available")
                    continuation.resume(returning: nil)
                    return
                }
                
                // Extract title, artist, album, etc.
                let title = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String
                let artist = info["kMRMediaRemoteNowPlayingInfoArtist"] as? String
                let album = info["kMRMediaRemoteNowPlayingInfoAlbum"] as? String
                let elapsedTime = info["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? Double
                let duration = info["kMRMediaRemoteNowPlayingInfoDuration"] as? Double
                let playbackRate = info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Double
                
                // Create NowPlayingInfo struct and return it
                let nowPlayingInfo = NowPlayingInfo(
                    title: title,
                    artist: artist,
                    album: album,
                    elapsedTime: elapsedTime,
                    duration: duration,
                    playbackRate: playbackRate
                )
                continuation.resume(returning: nowPlayingInfo)
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
}
