//
//  UrlSessionFecher.swift
//  MPreTest
//
//  Created by Chando Park on 6/23/24.
//

import Combine
import Foundation

class UrlSessionFecher: ListDataFecherType{
    struct NewsApiResponse: Codable {
        let status: String
        let totalResults: Int
        let articles: [ListModel]
        
    }
    func getList() -> AnyPublisher<[ListModel], FecherError> {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=9b68359293c947a09ea017b4f7282b07")!
        let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: NewsApiResponse.self, decoder: decoder)
            .tryMap({ res -> [ListModel]in
                print("🦊 response ::: \(res)")
                return res.articles
            })
            .mapError { err in
                if let decodingError = err as? DecodingError {
                    let message: String = {
                        switch decodingError {
                        case .typeMismatch(let any, let context):
                            return "could not find key \(any) in JSON: \(context.debugDescription)"
                        case .valueNotFound(let any, let context):
                            return "could not find key \(any) in JSON: \(context.debugDescription)"
                        case .keyNotFound(let codingKey, let context):
                            return "could not find key \(codingKey) in JSON: \(context.debugDescription)"
                        case .dataCorrupted(let context):
                            return "could not find key in JSON: \(context.debugDescription)"
                        @unknown default:
                            return err.localizedDescription
                        }
                    }()
                    
                    return FecherError.decodingErr(message: message)
                    
                } else if let error = err as? FecherError {
                    return error
                } else {
                    return FecherError.inServerError(code: (err as NSError).code, message: err.localizedDescription)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
