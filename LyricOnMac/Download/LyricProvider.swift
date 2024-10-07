//
//  LyricProvider.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/7.
//

import Foundation

protocol LyricProvider {
    func downloadLyric(for query: LyricQuery) async throws
}
