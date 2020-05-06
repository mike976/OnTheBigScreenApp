//
//  MediaCredit.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 06/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation


class MediaCredits {

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
}

