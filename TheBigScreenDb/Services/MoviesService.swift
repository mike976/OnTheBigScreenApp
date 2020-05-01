//
//  MoviesService.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 27/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation


protocol MoviesServiceProtocol {
    
    //MARK: - return list of movies now playing
    //MARK: - return list of movies in the Coming Soon
    //MARK: - return list of movies Trending
    //MARK: - return list of movies By Search
    //MARK: - return Movie Metadata
    //MARK: - return Cast Members for movie
    //MARK: - return Cast Member details
}


enum MovieEndPoint : String {
       case nowplaying_movies = "/movie/now_playing"
       case upcoming_movies="/movie/upcoming"
       case trending_movies="/trending/movie/day"
       case discover_movies = "/discover/movie"
       case search_movies = "/search/movie"
   }

class MoviesService : MoviesServiceProtocol {
    
    deinit {
        print("OS reclaiming memory - MoviesService - no retain cycle/memory leaks here")
    }
                
    let webClient = WebClient()
            
    var nextPage = 1
       
    
    private struct Parameters{
        static let language = ["language" : "en-GB"]
        static let api_key = ["api_key" : "5cd88ad1ae9b1b0d53d5e8467fe9c9bb"]
        static let sort_by = ["sort_by" : "popularity.desc"]
        static let page = ["page" : "1"]
    }
    
    private struct Parameter{
        var rawValue : Dictionary<String, String>
        init(parameter : Dictionary<String, String>){
            self.rawValue = parameter
        }
    }
    
    private struct Url{
        let baseUrl = "https://api.themoviedb.org/3"
        var path : MovieEndPoint
        var parameters : [Parameter]
        
        init(path : MovieEndPoint, parameters : [Parameter]) {
            self.path = path
            self.parameters = parameters
        }
    }
        
    
    private func fillUrl(url : Url) -> URL?{
        var urlComponents = URLComponents(string: url.baseUrl + url.path.rawValue)
        var queryItens = [URLQueryItem]()
        
        url.parameters.forEach({ (parameter) in
            queryItens.append(URLQueryItem(name: (parameter.rawValue.first?.key)!, value: parameter.rawValue.first?.value))
        })
        
        urlComponents?.queryItems = queryItens
        return urlComponents?.url
    }
    
    // MARK: Methods that calls API
    typealias getNowPlayingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getMovies(page : Int = 1, path: MovieEndPoint, onComplete : @escaping getNowPlayingMoviesOnComplete){
        
        let url = Url(path: path, parameters: [Parameter(parameter: Parameters.language), Parameter(parameter: Parameters.api_key), Parameter(parameter: Parameters.sort_by), Parameter(parameter : ["page" : "\(page)"])])
        
        webClient.request(url: fillUrl(url: url)) { (webResponse) in
            onComplete(Movie.returnMovies(json: webResponse.json!), webResponse)
        }
    }
    
}
