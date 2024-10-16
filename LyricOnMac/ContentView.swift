//
//  ContentView.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/4.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var playingManager = PlayingManager.shared

    var body: some View {
        VStack {
            if let lyrics = playingManager.currentLyrics {
                Text("Title: \(lyrics.metadata.title ?? "Unknown")")
                    .font(.headline)
                Text("Artist: \(lyrics.metadata.artist ?? "Unknown")")
                    .font(.subheadline)
                .font(.body)
            } else {
                Text("No lyrics")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
