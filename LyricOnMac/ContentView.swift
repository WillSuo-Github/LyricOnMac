//
//  ContentView.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/4.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var playingManager = PlayingManager.shared

    var body: some View {
        VStack {
            if let lyrics = playingManager.currentLyrics {
                Text("\(playingManager.currentLine ?? "Unknown")")
                    .font(.headline)
                    .layoutPriority(1)
                Text("\(playingManager.nextLine ?? "Unknown")")
                    .font(.subheadline)
                    .layoutPriority(1)
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
