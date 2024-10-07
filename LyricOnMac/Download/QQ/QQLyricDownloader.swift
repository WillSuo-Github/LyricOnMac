//
//  QQLyricDownloader.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/7.
//

import Foundation

final class QQLyricDownloader: LyricProvider {
    func downloadLyric(for query: LyricQuery) async throws {
        let baseURL = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp"
        let parameters = [
            "w": query.queryTerm(),
        ]
        guard let url = URL(string: baseURL + "?" + parameters.urlEncoded()) else { return }
        
        var (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let droped = data.map { data in

        }
        let decoder = JSONDecoder()
        let searchResult = try decoder.decode(QQSearchResponse.self, from: data)
        
        print(searchResult)
    }
}
