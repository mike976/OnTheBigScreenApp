//
//  MediaCredit.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 06/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation


class MediaCredits : MediaMetadataProtocol {

    var name: String
    var character: String
    var profilePath: URL?
    
    required init(json: [String: Any]) {
        
        self.name = json["name"] as? String ?? ""
        self.character = json["character"] as? String ?? ""
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(json["profile_path"] as? String ?? "")"){
            self.profilePath = url
        }
    }
    
    //TODO rewrite this to pull out the cast and crew arrays
    //refer to tmdb api and MediaDetail class
    
    
}


struct Cast {
    
}


struct Crew {
    
}

//{
//  "id": 481848,
//  "cast": [
//    {
//      "cast_id": 4,
//      "character": "John Thornton",
//      "credit_id": "5b4cec159251417d0f03c35d",
//      "gender": 2,
//      "id": 3,
//      "name": "Harrison Ford",
//      "order": 1,
//      "profile_path": "/5M7oN3sznp99hWYQ9sX0xheswWX.jpg"
//    },
//    {
//      "cast_id": 5,
//      "character": "Hal",
//      "credit_id": "5b57a8e40e0a2673d20427a7",
//      "gender": 2,
//      "id": 221018,
//      "name": "Dan Stevens",
//      "order": 2,
//      "profile_path": "/6ioq5zfiwSZbPRWY8fVUO8bWRBC.jpg"
//    },
//    {
//      "cast_id": 6,
//      "character": "Charles",
//      "credit_id": "5b889e279251414cf2002ae3",
//      "gender": 2,
//      "id": 1660946,
