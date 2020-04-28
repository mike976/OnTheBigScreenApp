//
//  Movie.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 27/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation


struct MovieResults : Codable {
    
    var results: [Movie]
    
    init () {
        
        self.results = [Movie]()
    }
}

struct Movie : Codable {
    
    var title: String
}

