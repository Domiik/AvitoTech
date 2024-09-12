//
//  UnsplashPhoto.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 06.09.2024.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let description: String?
    let user: User?
    let urls: [URLKing.RawValue:String]
    let likes: Int
    let created_at: String
    
    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct User: Decodable {
    let name: String
}
