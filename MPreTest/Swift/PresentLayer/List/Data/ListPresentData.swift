//
//  ListPresentData.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Foundation

struct ListPresentData {
    
    let title: String
    let urlToImage: URL?
    let publishedAt: String
    let url: URL
    
}

extension ListModel{
    func toPresentModel() -> ListPresentData{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return ListPresentData(title: self.title,
                               urlToImage: self.urlToImage,
                               publishedAt: formatter.string(from: self.publishedAt),
                               url: self.url)
    }
}
