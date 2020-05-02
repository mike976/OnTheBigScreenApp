//
//  MoviesService.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 27/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

protocol EndpointProtocol { }

enum MovieEndPoint : String, EndpointProtocol {
       case nowplaying_movies = "/movie/now_playing"
       case upcoming_movies="/movie/upcoming"
       case trending_movies="/trending/movie/day"
       case discover_movies = "/discover/movie"
       case search_movies = "/search/movie"
   }

enum TvShowEndPont : String, EndpointProtocol {
    case trending_tvshows = "/trending/tv/week"
}

protocol TheMovieDatabaseServiceProtocol {
    
    //MARK: - return list of movies By Search
    //MARK: - return Movie Metadata
    //MARK: - return Cast Members for movie
    //MARK: - return Cast Member details
    
    typealias getMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getMovies(page: Int, path: MovieEndPoint, onComplete : @escaping getMoviesOnComplete)
    
    typealias getTvShowsOnComplete = ([TvShow], WebResponse) -> Void
    func getTvShows(page : Int, path: TvShowEndPont, onComplete : @escaping getTvShowsOnComplete)
}

class TheMovieDatabaseService : TheMovieDatabaseServiceProtocol {
    
    deinit {
        print("OS reclaiming memory - MoviesService - no retain cycle/memory leaks here")
    }
                
    private var webClient: WebClientProtocol!
            
    private var nextPage = 1
           
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
    
    //TODO Refactor Convert to class and use inheritence
    private struct MovieUrl{
        let baseUrl = "https://api.themoviedb.org/3"
        var path : MovieEndPoint
        var parameters : [Parameter]
        
        init(path : MovieEndPoint, parameters : [Parameter]) {
            self.path = path
            self.parameters = parameters
        }
    }
    
    //TODO Refactor Convert to class and use inheritence
    private struct TvShowUrl{
        let baseUrl = "https://api.themoviedb.org/3"
        var path : TvShowEndPont
        var parameters : [Parameter]
        
        init(path : TvShowEndPont, parameters : [Parameter]) {
            self.path = path
            self.parameters = parameters
        }
    }
            
    private func fillMovieUrl(url : MovieUrl) -> URL?{
        var urlComponents = URLComponents(string: url.baseUrl + url.path.rawValue)
        var queryItens = [URLQueryItem]()
        
        url.parameters.forEach({ (parameter) in
            queryItens.append(URLQueryItem(name: (parameter.rawValue.first?.key)!, value: parameter.rawValue.first?.value))
        })
        
        urlComponents?.queryItems = queryItens
        return urlComponents?.url
    }
    
    private func fillTvShowUrl(url : TvShowUrl) -> URL?{
        var urlComponents = URLComponents(string: url.baseUrl + url.path.rawValue)
        var queryItens = [URLQueryItem]()
        
        url.parameters.forEach({ (parameter) in
            queryItens.append(URLQueryItem(name: (parameter.rawValue.first?.key)!, value: parameter.rawValue.first?.value))
        })
        
        urlComponents?.queryItems = queryItens
        return urlComponents?.url
    }
    
    required init(webClient: WebClientProtocol) {
        
        self.webClient = webClient
    }
    
    // MARK: Public Functions that call Web API
    typealias getMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getMovies(page : Int = 1, path: MovieEndPoint, onComplete : @escaping getMoviesOnComplete){
        
        let url = MovieUrl(path: path, parameters: [Parameter(parameter: Parameters.language), Parameter(parameter: Parameters.api_key), Parameter(parameter: Parameters.sort_by), Parameter(parameter : ["page" : "\(page)"])])
        
        webClient.request(url: fillMovieUrl(url: url)) { (webResponse) in
            onComplete(Movie.returnMovies(json: webResponse.json!), webResponse)
        }
    }
    
    typealias getTvShowsOnComplete = ([TvShow], WebResponse) -> Void
    func getTvShows(page : Int = 1, path: TvShowEndPont, onComplete : @escaping getTvShowsOnComplete){

        let url = TvShowUrl(path: path, parameters: [Parameter(parameter: Parameters.language), Parameter(parameter: Parameters.api_key), Parameter(parameter: Parameters.sort_by), Parameter(parameter : ["page" : "\(page)"])])

        webClient.request(url: fillTvShowUrl(url: url)) { (webResponse) in
            onComplete(TvShow.returnTvShows(json: webResponse.json!), webResponse)
        }
    }
    
}
