//
//  TvShow.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 01/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

struct TvShow {
    var name : String
    var first_air_date : String
    var overview : String
    var poster_path : URL?
    var backdrop_path : URL?
    var vote_average: String
    
    init(json : [String : Any]) {
        self.name = json["name"] as? String ?? ""
        self.first_air_date = (json["first_air_date"] as? String ?? "").formatedDate()
        self.overview = json["overview"] as! String
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(json["poster_path"] as? String ?? "")"){
            self.poster_path = url
        }
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(json["backdrop_path"] as? String ?? "")"){
            self.backdrop_path = url
        }
        self.vote_average = json["vote_average"] as? String ?? "0"
    }
    
    static func returnTvShows(json : [String : Any]) -> [TvShow]{
        let results = json["results"] as? NSArray
        var tvShows = [TvShow]()
        results?.forEach({ (tvShow) in
            let parsedTvShow = tvShow as! [String : Any]
            tvShows.append(TvShow(json: parsedTvShow))
        })
        return tvShows
    }
    
}
