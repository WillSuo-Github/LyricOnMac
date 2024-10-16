//
//  LyricsExtension.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/16.
//

import Foundation
@preconcurrency import LyricsCore

extension Lyrics.Metadata.Key {
    static let title = Lyrics.Metadata.Key("title")
    static let artist = Lyrics.Metadata.Key("artist")
}

extension Lyrics.Metadata {
    var title: String? {
        get { return data[.title] as? String }
        set { data[.title] = newValue }
    }
    
    var artist: String? {
        get { return data[.artist] as? String }
        set { data[.artist] = newValue }
    }
}
