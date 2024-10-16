//
//  LyricQuery.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/7.
//

import Foundation

final class LyricQuery: Sendable {
    private let song: Song
    
    init(song: Song) {
        self.song = song
    }
    
    func title() -> String {
        return song.title
    }
    
    func artist() -> String {
        return song.artist
    }
    
    func duration() -> Double {
        return song.duration ?? 0
    }
}
