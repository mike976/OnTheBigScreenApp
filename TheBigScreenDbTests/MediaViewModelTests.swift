//
//  TheBigScreenDbTests.swift
//  TheBigScreenDbTests
//
//  Created by Michael Bullock on 27/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import XCTest
import Swinject
@testable import On_The_Big_Screen

class FakeMovie : MediaProtocol {
    var title: String = "Bloodshot"
    
    var release_date: String = ""
    
    var release_year: String = ""
    
    var overview: String = ""
    
    var poster_path: URL?
    
    var backdrop_path: URL?
    
    var media_Type: MediaType?
    
    static func returnMediaList<T>(json: [String : Any]) -> [T] where T : MediaProtocol {
        let result = [T]()
        return result
    }
    
    
}

class MockMovieDatabaseService : TheMovieDatabaseServiceProtocol {
    func getMediaList<T>(page: Int, path: MediaEndpoint, searchQuery: String?, onComplete: @escaping getMediaOnComplete<T>) where T : MediaProtocol {
     
        var fakeMediaList = [T]()
        fakeMediaList.append(FakeMovie() as! T)
    
        let fakeWebResponse = WebResponse(json: ["":""], error: nil)
        
        onComplete(fakeMediaList, fakeWebResponse)
    }
    
    func getMediaDetail(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?, onComplete: @escaping getMediaDetailOnComplete) {
    }
    
    func getMediaCredits(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?, onComplete: @escaping getMediaCreditsOnComplete) {
    }
    
    
}

class MediaViewModelTests: XCTestCase {

    private let container = Container()
    
    private var _sut: MediaViewModelProtocol!

    override func setUp() {
        super.setUp()
        
        //register movie service using mock that returns mock movie
        self.container.register(TheMovieDatabaseServiceProtocol.self) { r in
               return MockMovieDatabaseService()
         }.inObjectScope(.container)
          
         self.container.register(MediaViewModelProtocol.self) { r in
            return MediaViewModel(movieDatabaseService: r.resolve(TheMovieDatabaseServiceProtocol.self)!)
        }

        _sut = container.resolve(MediaViewModelProtocol.self)
        
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testShouldReturnNowPlayingMovies() {
        
        let expectation = XCTestExpectation(description: "Fetch media")
        
        if let movies:[FakeMovie] = _sut.getMediaListAsync(page: 1, endpoint: .nowplaying_movies, nil) {
            
            print(movies.count)
            XCTAssert(movies.count == 1)
            XCTAssert(movies[0].title == "Bloodshot")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
