//
//  TvShow.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 01/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

class TvShow : Media {
    
    
    required override  init(json : [String : Any]) {
        
        super.init(json: json)
        
        self.title = json["name"] as? String ?? ""
        self.release_date = (json["first_air_date"] as? String ?? "").formatedDate()
        self.overview = json["overview"] as! String
    }
    
}
