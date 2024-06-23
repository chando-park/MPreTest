//
//  ListModel.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

struct Source: Codable {
    let id: String?
    let name: String
}

// Main article model
struct ListModel: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: URL
    let urlToImage: URL?
    let publishedAt: Date
    let content: String?
    
    var isRead: Bool? = false
}
