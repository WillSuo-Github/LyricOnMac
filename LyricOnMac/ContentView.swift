//
//  ContentView.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/4.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            let songUtility = SongUtility()
            songUtility.fetchNowPlayingInfo()
        }
    }
}

#Preview {
    ContentView()
}
