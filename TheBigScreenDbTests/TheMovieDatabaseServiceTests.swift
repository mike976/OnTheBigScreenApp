//
//  TheMovieDatabaseServiceTests.swift
//  TheBigScreenDbTests
//
//  Created by Michael Bullock on 13/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import XCTest
import Swinject
@testable import On_The_Big_Screen

class TheMovieDatabaseServiceTests: XCTestCase {

    private let container = Container()
    private var _sut: TheMovieDatabaseServiceProtocol!
    
    override func setUp() {
        super.setUp()
    
        //register webclient using mock that returns mock movie json test data
         self.container.register(WebClientProtocol.self) { r in
             return MockWebClient()
         }.inObjectScope(.container)
        
        self.container.register(TheMovieDatabaseServiceProtocol.self) { r in
            return TheMovieDatabaseService(webClient: r.resolve(WebClientProtocol.self)!)
        }
                    
        _sut = container.resolve(TheMovieDatabaseServiceProtocol.self)
        
    }
    
    func testShouldReturnNowPlayingMovies() {
                
         let expectation = XCTestExpectation(description: "Fetch media")
                        
        _ = _sut.getMediaList(page: 1, path: .nowplaying_movies, searchQuery: "") { (mediaList: [Movie], response) in
            
            XCTAssert(mediaList.count == 1)
            XCTAssert(mediaList[0].title == "Bloodshot")
            XCTAssert(mediaList[0].media_Type == MediaType.movie)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    override class func tearDown() {
        super.tearDown()

        
    }
    
}


