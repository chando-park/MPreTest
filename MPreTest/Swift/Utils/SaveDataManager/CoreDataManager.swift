//
//  CoreDataManager.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Foundation
import CoreData
import Combine
class CoreDataManager: SaveDataManagerType {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MPreTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveNewsItem(_ item: ListModel) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return promise(.failure(NSError())) }
            let newsItem = NewsItem(context: self.context)
            newsItem.title = item.title
            newsItem.publishedAt = item.publishedAt
            newsItem.urlToImage = item.urlToImage
            newsItem.url = item.url
            
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchNewsItems() -> AnyPublisher<[ListModel], Error> {
        Future { [weak self] promise in
            guard let self = self else { return promise(.failure(NSError())) }
            let request: NSFetchRequest<NewsItem> = NewsItem.fetchRequest()
            
            do {
                let results = try self.context.fetch(request)
                let listModels = results.map {
                    ListModel(source: Source(id: nil, name: ""), author: nil, title: $0.title ?? "", description: nil, url: $0.url ?? URL(string: "http://example.com")!, urlToImage: $0.urlToImage, publishedAt: $0.publishedAt ?? Date(), content: nil)
                }
                promise(.success(listModels))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

