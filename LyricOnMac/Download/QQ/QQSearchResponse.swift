//
//  QQSearchResponse.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/7.
//

import Foundation

struct QQSearchResponse: Decodable {
    let data: Data
    let code: Int
    
    struct Data: Decodable {
        let song: Song
        
        struct Song: Decodable {
            let list: [Item]
            
            struct Item: Decodable {
                let songmid: String
                let songname: String
                let albumname: String
                let singer: [Singer]
                let interval: Int
                
                struct Singer: Decodable {
                    let name: String
                }
            }
        }
    }
}
