//
//  MoviesService.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 27/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

protocol MediaEndpointProtocol { }

enum MediaEndpoint : String, MediaEndpointProtocol {
       case nowplaying_movies = "/movie/now_playing"
       case upcoming_movies="/movie/upcoming"
       case trending_movies="/trending/movie/day"
       case discover_movies = "/discover/movie"
       case search_movies = "/search/multi"
       case trending_tvshows = "/trending/tv/day"
    
       case tvShowDetails = "/tv/{tvId}"
       case movieDetails = "/movie/{movieId}"
    
       case tvShowCredits = "/tv/{tvId}/credits"
       case movieCredits = "/movie/{movieId}/credits"



    //       case .person="/person/\(personId)" -- implement this endpoint in subsequent versions
}


protocol TheMovieDatabaseServiceProtocol {
    
    typealias getMediaOnComplete<T:MediaProtocol> = ([T], WebResponse) -> Void
    func getMediaList<T:MediaProtocol>(page: Int, path: MediaEndpoint, searchQuery: String?, onComplete : @escaping getMediaOnComplete<T>)
    
    typealias getMediaDetailOnComplete = (MediaDetail, WebResponse) -> Void
    func getMediaDetail(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?, onComplete : @escaping getMediaDetailOnComplete)
    
    typealias getMediaCreditsOnComplete = (MediaCredits, WebResponse) -> Void
    func getMediaCredits(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?, onComplete : @escaping getMediaCreditsOnComplete)
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
        static let query = ["query": ""]
    }
    
    private struct Parameter{
        var rawValue : Dictionary<String, String>
        init(parameter : Dictionary<String, String>){
            self.rawValue = parameter
        }
    }
    
       private struct MediaUrl{
        let baseUrl = "https://api.themoviedb.org/3"
        var path : MediaEndpoint
        var parameters : [Parameter]
        
        init(path : MediaEndpoint, parameters : [Parameter]) {
            self.path = path
            self.parameters = parameters
        }
    }
    
            
    private func fillMediaUrl(url : MediaUrl) -> URL?{
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
   
    typealias getMediaOnComplete<T:MediaProtocol> = ([T], WebResponse) -> Void
    func getMediaList<T:MediaProtocol>(page : Int = 1, path: MediaEndpoint, searchQuery: String?, onComplete : @escaping getMediaOnComplete<T>) {

        var parameters = [Parameter(parameter: Parameters.language), Parameter(parameter: Parameters.api_key), Parameter(parameter: Parameters.sort_by), Parameter(parameter : ["page" : "\(page)"])]
        
        
        if let searchQueryString = searchQuery {
            var query = Parameters.query
            query.updateValue(searchQueryString, forKey: "query")
            parameters.append(Parameter(parameter: query ))
        }
        
        let url = MediaUrl(path: path, parameters: parameters)

        webClient.request(url: fillMediaUrl(url: url)) { (webResponse) in
            onComplete(T.returnMediaList(json: webResponse.json!) as [T], webResponse)
        }
    }
    

    typealias getMediaDetailOnComplete = (MediaDetail, WebResponse) -> Void
    func getMediaDetail(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?, onComplete : @escaping getMediaDetailOnComplete) {
        
        if mediaId == nil {
            print("error no media id suppled to retrieve media detail")
            return
        }
        
        var parameters = [Parameter(parameter: Parameters.language), Parameter(parameter: Parameters.api_key), Parameter(parameter: Parameters.sort_by)]
        
        var parameterKeyToAdd = ""
        if mediaType == .movie {
            parameterKeyToAdd = "movie_id"
        }
        
        if mediaType == .tvShow {
            parameterKeyToAdd = "tv_id"
        }
        
        parameters.append(Parameter(parameter: [parameterKeyToAdd: "\(mediaId!)"]))

        let url = MediaUrl(path: path, parameters: parameters)

        webClient.request(url: fillMediaUrl(url: url)) { (webResponse) in

            onComplete(MediaDetail(json: webResponse.json!), webResponse)
            
            
        }
    }
    
    typealias getMediaCreditsOnComplete = (MediaCredits, WebResponse) -> Void
    func getMediaCredits(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?, onComplete : @escaping getMediaCreditsOnComplete) {

        if mediaId == nil {
            print("error no media id suppled to retrieve media detail")
            return
        }
        
        var parameters = [Parameter(parameter: Parameters.language), Parameter(parameter: Parameters.api_key), Parameter(parameter: Parameters.sort_by)]
        
        var parameterKeyToAdd = ""
        if mediaType == .movie {
            parameterKeyToAdd = "movie_id"
        }
        
        if mediaType == .tvShow {
            parameterKeyToAdd = "tv_id"
        }
        
        parameters.append(Parameter(parameter: [parameterKeyToAdd: "\(mediaId!)/credits"]))

        let url = MediaUrl(path: path, parameters: parameters)

        webClient.request(url: fillMediaUrl(url: url)) { (webResponse) in
           onComplete(MediaCredits(json: webResponse.json!), webResponse)
        }
    }
    
            
}
