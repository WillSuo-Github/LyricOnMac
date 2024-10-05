//
//  SongUtility.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/4.
//

import Foundation
import MediaPlayer
import Combine

class SongUtility: ObservableObject {
    // MARK: - Constants
    private let kMediaRemotePath = "/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote"
    private let timerInterval: Double = 0.1

    private var MRIsMediaRemoteLoaded = false
    private var nowPlayingInfo: NowPlayingInfo?
    private var timer: DispatchSourceTimer?
    private var lastUpdateTime: Date = Date()

    // Combine publisher
    private let nowPlayingInfoSubject = CurrentValueSubject<NowPlayingInfo?, Never>(nil)
    var nowPlayingInfoPublisher: AnyPublisher<NowPlayingInfo?, Never> {
        nowPlayingInfoSubject.eraseToAnyPublisher()
    }

    // Function Pointers
    typealias MRMediaRemoteGetNowPlayingInfoType = @convention(c) (DispatchQueue, @escaping (CFDictionary?) -> Void) -> Void
    typealias MRMediaRemoteRegisterForNowPlayingNotificationsType = @convention(c) (DispatchQueue) -> Void

    var MRMediaRemoteGetNowPlayingInfo: MRMediaRemoteGetNowPlayingInfoType?
    var MRMediaRemoteRegisterForNowPlayingNotifications: MRMediaRemoteRegisterForNowPlayingNotificationsType?

    init() {
        loadMediaRemote()
        registerForNowPlayingNotifications()
        fetchNowPlayingInfo()
    }

    // Load MediaRemote Framework
    private func loadMediaRemote() {
        guard let handle = dlopen(kMediaRemotePath, RTLD_LAZY) else {
            print("Failed to load MediaRemote framework")
            return
        }

        MRIsMediaRemoteLoaded = true
        MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(dlsym(handle, "MRMediaRemoteGetNowPlayingInfo"), to: MRMediaRemoteGetNowPlayingInfoType?.self)
        MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(dlsym(handle, "MRMediaRemoteRegisterForNowPlayingNotifications"), to: MRMediaRemoteRegisterForNowPlayingNotificationsType?.self)

        dlclose(handle)
    }

    private func registerForNowPlayingNotifications() {
        MRMediaRemoteRegisterForNowPlayingNotifications?(DispatchQueue.main)

        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingInfoDidChange), name: .mediaRemoteNowPlayingApplicationPlaybackStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingInfoDidChange), name: .mediaRemoteNowPlayingInfoDidChange, object: nil)
    }

    @objc private func nowPlayingInfoDidChange(notification: Notification) {
        print("Now Playing Info Did Change")
        fetchNowPlayingInfo()
    }

    private func fetchNowPlayingInfo() {
        guard MRIsMediaRemoteLoaded, let getNowPlayingInfo = MRMediaRemoteGetNowPlayingInfo else {
            print("MediaRemote framework not loaded")
            return
        }

        getNowPlayingInfo(DispatchQueue.main) { [weak self] nowPlayingInfo in
            guard let self = self else { return }
            guard let info = nowPlayingInfo as? [String: Any] else {
                print("No Now Playing Info available")
                self.nowPlayingInfoSubject.send(nil)
                return
            }

            let title = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String
            let artist = info["kMRMediaRemoteNowPlayingInfoArtist"] as? String
            let album = info["kMRMediaRemoteNowPlayingInfoAlbum"] as? String
            let elapsedTime = info["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? Double ?? 0
            let duration = info["kMRMediaRemoteNowPlayingInfoDuration"] as? Double
            let playbackRate = info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Double ?? 0

            let timestamp = info["kMRMediaRemoteNowPlayingInfoTimestamp"] as? Date ?? Date()

            let currentTime = Date()

            let timeSinceTimestamp = currentTime.timeIntervalSince(timestamp)

            let currentElapsedTime = max(elapsedTime + timeSinceTimestamp * playbackRate, 0)

            let nowPlayingInfo = NowPlayingInfo(
                title: title,
                artist: artist,
                album: album,
                elapsedTime: currentElapsedTime,
                duration: duration,
                playbackRate: playbackRate
            )

            self.nowPlayingInfo = nowPlayingInfo
            self.nowPlayingInfoSubject.send(nowPlayingInfo)

            self.startElapsedTimeTimer()
        }
    }

    private func startElapsedTimeTimer() {
        // Cancel the old timer if one exists
        timer?.cancel()
        timer = nil

        guard let nowPlayingInfo = nowPlayingInfo, nowPlayingInfo.playbackRate != 0 else {
            return
        }

        lastUpdateTime = Date()

        // Create a new timer
        let queue = DispatchQueue.main
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now() + timerInterval, repeating: timerInterval)
        timer?.setEventHandler { [weak self] in
            self?.updateElapsedTime()
        }
        timer?.resume()
    }

    private func updateElapsedTime() {
        guard var nowPlayingInfo = nowPlayingInfo else { return }

        if nowPlayingInfo.playbackRate == 0 {
            timer?.cancel()
            timer = nil
            return
        }

        let currentTime = Date()

        let timeSinceLastUpdate = currentTime.timeIntervalSince(lastUpdateTime)
        lastUpdateTime = currentTime

        nowPlayingInfo.elapsedTime += timeSinceLastUpdate * nowPlayingInfo.playbackRate

        self.nowPlayingInfo = nowPlayingInfo

        nowPlayingInfoSubject.send(nowPlayingInfo)
    }
}

private extension Notification.Name {
    static let mediaRemoteNowPlayingInfoDidChange = Notification.Name("kMRMediaRemoteNowPlayingInfoDidChangeNotification")
    static let mediaRemoteNowPlayingApplicationPlaybackStateDidChange = Notification.Name("kMRMediaRemoteNowPlayingApplicationPlaybackStateDidChangeNotification")
}
