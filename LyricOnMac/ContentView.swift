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
            if playingManager.currentLyrics != nil {
                if let firstLine = playingManager.currentLine {
                    Text(firstLine)
                        .font(.custom("SF Compact Rounded", size: 32))
                        .foregroundStyle(.cyan)
                }
                if let secondLine = playingManager.nextLine {
                    Text(secondLine)
                        .font(.custom("SF Compact Rounded", size: 20))
                        .foregroundStyle(.cyan)
                }
            } else {
                Text("No lyrics")
                    .font(.custom("SF Compact Rounded", size: 32))
                    .foregroundStyle(.cyan)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
