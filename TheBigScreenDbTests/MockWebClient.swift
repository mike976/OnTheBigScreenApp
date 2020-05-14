//
//  MockWebClient.swift
//  TheBigScreenDbTests
//
//  Created by Michael Bullock on 14/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import XCTest
import Foundation
@testable import On_The_Big_Screen

class MockWebClient: WebClientProtocol {
    
        
    //does not actually make URL request but returns a mocked data json result using json test data files from this test project
    func request(url: URL?, onComplete: @escaping requestOnComplete) {
      let data = readJSON(name: "nowPlayingMovie")!
        
      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
    
      //return mock json response
      onComplete(WebResponse(json: json, error: nil))
      return
      
    }

    
    private func readJSON(name: String) -> Data? {
      let bundle = Bundle(for: TheMovieDatabaseServiceTests.self)
      guard let url = bundle.url(forResource: name, withExtension: "json") else { return nil }
      
      do {
        return try Data(contentsOf: url, options: .mappedIfSafe)
      }
      catch {
        XCTFail("Error occurred parsing test data")
        return nil
      }
    }
}
