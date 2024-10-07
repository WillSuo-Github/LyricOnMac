//
//  DownloadManager.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/7.
//

import Foundation
@preconcurrency import Combine

final class DownloadManager: @unchecked Sendable {
    static let shared = DownloadManager()
    
    private let songUtility = SongUtility()
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        subscribeToNowPlayingInfo()
    }
    
    private func subscribeToNowPlayingInfo() {
        songUtility.nowPlayingSongPublisher
            .scan((nil, nil), { previous, current in
                return (previous.1, current)
            })
            .filter({ previous, current in
                guard let previous = previous else { return true }
                guard let current = current else { return false }
                return !previous.isSameSong(as: current)
            })
            .compactMap { _, current in
                return current
            }
            .compactMap {
                return LyricQuery(song: $0)
            }
            .sink { [weak self] song in
                self?.downloadLyric(for: song)
            }
            .store(in: &cancellables)
    }
    
    private func downloadLyric(for query: LyricQuery) {
        Task {
            do {
                try await QQLyricDownloader().downloadLyric(for: query)
            } catch {
                print(error)
            }
        }
    }
}
