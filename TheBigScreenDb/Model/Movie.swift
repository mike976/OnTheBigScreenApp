//
//  Movie.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 27/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//
//        self.release_date = (json["release_date"] as? String ?? "").formatedDate()
//        self.title = json["title"] as? String ?? ""
import Foundation


class Movie: Media {
    
    
    required override init(json : [String : Any]) {

        super.init(json: json)
        
        self.release_date = (json["release_date"] as? String ?? "").formatedDate()
        self.release_year = (json["release_date"] as? String ?? "").formatedYear()
        self.title = json["title"] as? String ?? ""
        self.media_Type = MediaType.movie
        
    }
           
}

