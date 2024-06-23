//
//  SaveDataManagerType.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine



protocol SaveDataManagerType{
    func saveNewsItem(_ item: ListModel) -> AnyPublisher<Void, Error>
    func fetchNewsItems() -> AnyPublisher<[ListModel], Error>
}

