//
//  ContentView.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/4.
//

import SwiftUI
import Combine

struct ContentView: View {
    private var songUtility = SongUtility()
    @State private var nowPlayingInfo: Song?
    @State private var cancellables = Set<AnyCancellable>()
    let downloadManager = DownloadManager.shared

    var body: some View {
        VStack {
            if let info = nowPlayingInfo {
                Text("Title: \(info.title ?? "Unknown")")
                    .font(.headline)
                Text("Artist: \(info.artist ?? "Unknown")")
                    .font(.subheadline)
                Text("Elapsed time: \(String(format: """
                    %02d:%02d
                    """, Int(info.elapsedTime) / 60, Int(info.elapsedTime) % 60))")
                    .font(.body)
            } else {
                Text("No music is playing.")
            }
        }
        .padding()
        .onAppear {
            subscribeToNowPlayingInfo()
        }
    }

    private func subscribeToNowPlayingInfo() {
        songUtility.nowPlayingSongPublisher
            .receive(on: DispatchQueue.main)
            .sink { info in
                self.nowPlayingInfo = info
            }
            .store(in: &cancellables)
    }
}

#Preview {
    ContentView()
}
