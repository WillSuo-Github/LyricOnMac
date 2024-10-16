//
//  LyricDownloader.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/7.
//

import Foundation
import LyricsService
import Combine

final class LyricDownloader {
    private var cancellables: Set<AnyCancellable> = []
    private let provider = LyricsProviders.Group(service: [.kugou, .netease, .qq])

    func downloadLyric(for query: LyricQuery) -> AnyPublisher<Lyrics, Never> {
        let searchReq = LyricsSearchRequest(
            searchTerm: .info(title: query.title(), artist: query.artist()),
            duration: query.duration()
        )
        
        print("start download lyric")
        
        return provider.lyricsPublisher(request: searchReq)
            .reduce(nil) { (currentMax: Lyrics?, newLyrics: Lyrics) -> Lyrics? in
                guard let currentMax = currentMax else {
                    return newLyrics
                }
                return newLyrics.quality > currentMax.quality ? newLyrics : currentMax
            }
            .compactMap { $0 }
            .map { lyrics -> Lyrics in
                let updatedLyrics = lyrics
                updatedLyrics.metadata.title = query.title()
                updatedLyrics.metadata.artist = query.artist()
                return updatedLyrics
            }
            .eraseToAnyPublisher()
    }
}
