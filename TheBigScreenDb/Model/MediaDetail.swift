//
//  MediaDetail.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 06/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

protocol MediaMetadataProtocol {
        
}

class MediaDetail : MediaMetadataProtocol {
 
    var productionCompanies : [ProductionCompany]?
    var trailers: [Trailer]?
    
    required init(json : [String : Any]) {
        
        if let productionCompanyResults = json["production_companies"] as? NSArray {
            var productioncompanyReturnList = [ProductionCompany]()
            productionCompanyResults.forEach( { (pc) in
                
                let parsedPc = pc as! [String : Any]
            
                if let companyName = parsedPc["name"] as! String? {
                        
                    var logoPath: URL?
                    if let url = URL(string: "https://image.tmdb.org/t/p/w500\(parsedPc["logo_path"] as? String ?? "")") {

                        logoPath = url
                    }

                        
                    productioncompanyReturnList.append(ProductionCompany(name: companyName, logoPath: logoPath))
                }
                    
            })
            
            self.productionCompanies = productioncompanyReturnList
        }
        
        if let videoDict = json["videos"] as? NSDictionary
        {
            if let results = videoDict["results"] as? NSArray {
                var trailerReturnList = [Trailer]()
                results.forEach( { (result) in
                
                    let parsedResult = result as! [String : Any]
            
                    var trailerUrl: URL?
                    if let url = URL(string: "https://www.youtube.com/watch?v=\(parsedResult["key"] as? String ?? "")") {
                        trailerUrl = url
                    }
                    
                    trailerReturnList.append(Trailer(url: trailerUrl))
                })
                           
                self.trailers = trailerReturnList
            }
        }
    }
}

struct ProductionCompany {
    
    var name: String
    var logoPath: URL?
    
    init(name: String, logoPath: URL?){
        self.name = name
        self.logoPath = logoPath
    }
}

struct Trailer {
    var url: URL?
    
    init(url: URL?){
        self.url = url
    }
}


