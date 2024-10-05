//
//  NowPlayingInfo.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/5.
//

import Foundation

// NowPlayingInfo struct to encapsulate the now playing information
struct NowPlayingInfo {
    let title: String?
    let artist: String?
    let album: String?
    var elapsedTime: Double
    let duration: Double?
    let playbackRate: Double
}
