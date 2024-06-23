//
//  MockFecher.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

class MockListDataFetcher: ListDataFecherType {
    func getList() -> AnyPublisher<[ListModel], FecherError> {
        let models = [
            ListModel(source: Source(id: "1", name: "Source 1"), author: "Author 1", title: "Title 1", description: "Description 1", url: URL(string: "https://example.com/1")!, urlToImage: nil, publishedAt: Date(), content: "Content 1"),
            ListModel(source: Source(id: "2", name: "Source 2"), author: "Author 2", title: "Title 2", description: "Description 2", url: URL(string: "https://example.com/2")!, urlToImage: nil, publishedAt: Date(), content: "Content 2")
        ]
        
        return Just(models)
            .setFailureType(to: FecherError.self)
            .eraseToAnyPublisher()
    }
}
