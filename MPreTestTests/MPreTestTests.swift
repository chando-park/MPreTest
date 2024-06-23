//
//  MPreTestTests.swift
//  MPreTestTests
//
//  Created by Chando Park on 6/22/24.
//

import XCTest
@testable import MPreTest
import Combine

final class MPreTestTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchTopHeadlinesNetworkCall() {
        // NewsApiClient 인스턴스 생성
        let fecher = UrlSessionFecher()
        
        // 네트워크 요청에 대한 기대 설정
        let expectation = self.expectation(description: "FetchTopHeadlinesNetworkCall")
        
        // fetchTopHeadlines 호출 및 결과 처리
        fecher.getList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("네트워크 요청 실패: \(error)")
                }
            }, receiveValue: { articles in
                XCTAssertGreaterThan(articles.count, 0, "기사는 최소한 하나 이상이어야 합니다.")
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        // 네트워크 요청이 완료될 때까지 대기
        waitForExpectations(timeout: 10, handler: nil)
    }
}
