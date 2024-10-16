//
//  PlayingManager.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/7.
//

import Foundation
import Combine
import LyricsCore

@Observable
final class PlayingManager {
    @MainActor static let shared = PlayingManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let songUtility = SongUtility()
    private let downloader = LyricDownloader()
    private let lyricCacher = LyricCacher()
    
    private(set) var currentLyrics: Lyrics?
    
    private init() {
        subscribeToNowPlayingInfo()
    }
    
    private func subscribeToNowPlayingInfo() {
        songUtility.nowPlayingSongPublisher
            .scan((nil, nil), { previous, current in
                return (previous.1, current)
            })
            .filter { previous, current in
                // 过滤重复歌曲
                guard let previous = previous else { return true }
                guard let current = current else { return false }
                return !previous.isSameSong(as: current)
            }
            .sink { [weak self] _, current in
                if let current = current {
                    // 如果有新的歌曲，下载歌词
                    let query = LyricQuery(song: current)
                    self?.downloadLyric(for: query)
                } else {
                    // 如果接收到 nil，清空 currentLyrics
                    self?.currentLyrics = nil
                }
            }
            .store(in: &cancellables)
    }
    
    private func downloadLyric(for query: LyricQuery) {
        fetchLyric(for: query)
            .sink { [weak self] lyrics in
                self?.currentLyrics = lyrics
            }
            .store(in: &cancellables)
    }
    
    private func fetchLyric(for query: LyricQuery) -> AnyPublisher<Lyrics, Never> {
        return lyricCacher.fetchLyrics(for: query, from: downloader)
    }
}
