//
//  Song.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/5.
//

import Foundation

// Song struct to encapsulate the now playing information
struct Song {
    let title: String
    let artist: String
    let album: String?
    var elapsedTime: Double
    let duration: Double?
    let playbackRate: Double
}

// MARK: - Equatable
extension Song {
    func isSameSong(as song: Song) -> Bool {
        return title == song.title && artist == song.artist
    }
}
