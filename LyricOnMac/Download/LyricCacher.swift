//
//  LyricCacher.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/15.
//

import Foundation
import Combine
import LyricsCore

final class LyricCacher {
    private let cacheDirectory: URL
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("LyricsCache")
    
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func cacheLyrics(_ lyrics: Lyrics, for query: LyricQuery) {
        let fileName = cacheFileName(for: query)
        let filePath = cacheDirectory.appendingPathComponent(fileName)
        
        do {
            let data = lyrics.description.data(using: .utf8)
            try data?.write(to: filePath)
            print("Lyrics cached at: \(filePath)")
        } catch {
            print("Failed to cache lyrics: \(error)")
        }
    }
    
    private func loadCachedLyrics(for query: LyricQuery) -> Lyrics? {
        let fileName = cacheFileName(for: query)
        let filePath = cacheDirectory.appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: filePath)
            if let lyricsText = String(data: data, encoding: .utf8) {
                let lyrics = Lyrics(lyricsText)
                lyrics?.metadata.title = query.title()
                lyrics?.metadata.artist = query.artist()
                return lyrics
            }
        } catch {
            print("No cached lyrics found for: \(filePath)")
        }
        return nil
    }
    
    private func cacheFileName(for query: LyricQuery) -> String {
        return "\(query.title())_\(query.artist()).lrcx".replacingOccurrences(of: "/", with: "_")
    }
    
    func fetchLyrics(for query: LyricQuery, from downloader: LyricDownloader) -> AnyPublisher<Lyrics, Never> {
        if let cachedLyrics = loadCachedLyrics(for: query) {
            return Just(cachedLyrics).eraseToAnyPublisher()
        } else {
            return downloader.downloadLyric(for: query)
                .handleEvents(receiveOutput: { [weak self] lyrics in
                    self?.cacheLyrics(lyrics, for: query)
                })
                .eraseToAnyPublisher()
        }
    }
}
