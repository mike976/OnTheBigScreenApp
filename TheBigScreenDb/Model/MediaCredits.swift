//
//  MediaCredit.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 06/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation


class MediaCredits : MediaMetadataProtocol {

    var cast: [Cast]?
    var crew: [Crew]?
    
    required init(json: [String: Any]) {
 
        
        if let castResults = json["cast"] as? NSArray {
            var castReturnList = [Cast]()
            castResults.forEach( { (cast) in
                
                let parsedCast = cast as! [String : Any]
                let name = parsedCast["name"] as! String? ?? ""
                let character = parsedCast["character"] as! String? ?? ""
                
                var imageURL: URL?
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(parsedCast["profile_path"] as? String ?? "")") {
                    imageURL = url
                }
                
                    
                castReturnList.append(Cast(name: name, character: character, imageUrl: imageURL))
                    
            })
            
            self.cast = castReturnList
        }
        
        if let crewResults = json["crew"] as? NSArray {
            var crewReturnList = [Crew]()
            crewResults.forEach( { (crew) in
                
                let parsedCrew = crew as! [String : Any]
                let name = parsedCrew["name"] as! String? ?? ""
                let job = parsedCrew["job"] as! String? ?? ""
                
                var imageURL: URL?
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(parsedCrew["profile_path"] as? String ?? "")") {
                    imageURL = url
                }
                    
                crewReturnList.append(Crew(name: name, job: job, imageUrl: imageURL))
                    
            })
            
            self.crew = crewReturnList
        }
 
    }
 }


struct Cast {
    var name: String
    var character: String
    var imageUrl : URL?
}


struct Crew {
    var name:String
    var job:String
    var imageUrl: URL?
}
