//
//  NewsHubTests.swift
//  NewsHubTests
//
//  Created by Nick M on 11.06.2022.
//

import XCTest
@testable import NewsHub

class NewsHubTests: XCTestCase {
    
    var newsData: [ArticlesList]?

    func test_uploadNewsData(){
        
        let exp = XCTestExpectation(description: "Data is not loaded")
        NewsService().requestNewsData("top-headlines?category=business") { recivedNewsData,_  in
            self.newsData = recivedNewsData
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
        XCTAssertTrue(newsData?.count ?? 0 > 0)
    }

}
