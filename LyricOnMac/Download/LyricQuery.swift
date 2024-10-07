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
    
    func queryTerm() -> String {
        return "\(song.artist) \(song.title)"
    }
}
