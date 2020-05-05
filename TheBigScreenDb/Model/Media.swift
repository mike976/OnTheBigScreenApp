//
//  Media.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 04/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

enum MediaType {
    case movie
    case tvShow
    case unknown
}

protocol MediaProtocol {
    var title : String { get set }
       var release_date : String  { get set }
       var release_year: String { get set }
       var overview : String  { get set }
       var poster_path : URL?  { get set }
       var backdrop_path : URL?  { get set }
       var media_Type: MediaType? { get set }
    
        static func returnMediaList<T: MediaProtocol>(json : [String : Any]) -> [T]
}

class Media : MediaProtocol {
    
    var title : String
    var release_date : String
    var release_year: String
    var overview : String
    var poster_path : URL?
    var backdrop_path : URL?
    var media_Type: MediaType?
    var vote_average: Double?
    
    init(json : [String : Any]) {
        self.title = ""
        self.release_date = ""
        self.release_year = ""
        self.overview = json["overview"] as? String ?? ""
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(json["poster_path"] as? String ?? "")"){
            self.poster_path = url
        }
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(json["backdrop_path"] as? String ?? "")"){
            self.backdrop_path = url
        }
        
        self.vote_average = json["vote_average"] as? Double ?? 0.0
        
    }
    
    static func returnMediaList<T: MediaProtocol>(json : [String : Any]) -> [T]{
        
        let results = json["results"] as? NSArray
        var mediaList = [T]()
        results?.forEach({ (media) in
            let parsedMedia = media as! [String : Any]
            
            if T.self == Movie.self {
                mediaList.append(Movie(json: parsedMedia) as! T)
            } else if T.self == TvShow.self {
                mediaList.append(TvShow(json: parsedMedia) as! T)
            } else if T.self == Media.self {

                if let mediaType = parsedMedia["media_type"] as! String? {
                    
                    if mediaType == "movie" {
                        mediaList.append(Movie(json: parsedMedia) as! T)
                    } else if mediaType == "tv" {
                        mediaList.append(TvShow(json: parsedMedia) as! T)
                    }
                }
            }            
        })
        
        
        return mediaList
    }
        
}




 
