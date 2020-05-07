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
    
    required init(json : [String : Any]) {
        
        if let productionCompanyResults = json["production_companies"] as? NSArray {
            var productioncompanyReturnList = [ProductionCompany]()
            productionCompanyResults.forEach( { (pc) in
                
                let parsedPc = pc as! [String : Any]
            
                    if let companyName = parsedPc["name"] as! String? {
                        
                         if let logoPath = URL(string: "https://image.tmdb.org/t/p/w500\(json["logo_path"] as? String ?? "")") {
                            
                            productioncompanyReturnList.append(ProductionCompany(name: companyName, logoPath: logoPath))
                        }
                    }
                })
            
            self.productionCompanies = productioncompanyReturnList
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


