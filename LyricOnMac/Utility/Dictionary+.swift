//
//  Dictionary+.swift
//  LyricOnMac
//
//  Created by will Suo on 2024/10/7.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    func queryItems() -> [URLQueryItem] {
        return map { key, value in
            URLQueryItem(name: key, value: value as String)
        }
    }
    
    func urlEncoded() -> String {
        return queryItems()
            .map { item in
                return "\(item.name)=\(item.value ?? "")"
            }
            .joined(separator: "&")
    }
}
