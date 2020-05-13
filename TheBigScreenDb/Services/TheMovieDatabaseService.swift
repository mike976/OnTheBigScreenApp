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
    
       case tvShow = "/tv/"
       case movie = "/movie/"
    
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
    
    private static var apiKey: String = {
        guard let filePath: String = Bundle.main.path(forResource: "Services", ofType: "plist") else { fatalError("Couldn't find Services.plist") }
        guard let dict = NSDictionary(contentsOfFile: filePath) else { fatalError("Can't read Services.plist") }
        guard let apiKey = dict["TMDbAPIKey"] as? String else { fatalError("Couldn't find a value for 'TMDbAPIKey'") }
        return apiKey
    }()
                
    private var webClient: WebClientProtocol!
            
    private var nextPage = 1
           
    private struct Parameters{
        static let language = ["language" : "en-GB"]
        static let api_key = ["api_key" : "\(apiKey)"]
        static let sort_by = ["sort_by" : "popularity.desc"]
        static let page = ["page" : "1"]
        static let query = ["query": ""]
        static let videos = ["append_to_response": "videos"]
    }
    
    private struct Parameter{
        var rawValue : Dictionary<String, String>
        init(parameter : Dictionary<String, String>){
            self.rawValue = parameter
        }
    }
    
       private struct MediaUrl{
        var baseUrl = "https://api.themoviedb.org/3"
        var path : MediaEndpoint
        var pathArgs: String?
        var parameters : [Parameter]
        
        init(path : MediaEndpoint, pathArgs: String?, parameters : [Parameter]) {
            self.path = path
            self.pathArgs = pathArgs
            self.parameters = parameters
        }
    }
    
            
    private func fillMediaUrl(url : MediaUrl) -> URL?{
        var urlComponents = url.pathArgs == nil ?  URLComponents(string: url.baseUrl + url.path.rawValue) : URLComponents(string: url.baseUrl + url.path.rawValue + url.pathArgs!)
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
        
        let url = MediaUrl(path: path, pathArgs: nil,  parameters: parameters)

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
        
        let parameters = [Parameter(parameter: Parameters.language), Parameter(parameter: Parameters.api_key), Parameter(parameter: Parameters.videos)]
        
        let pathArgs = "\(mediaId!)"
        

        let url = MediaUrl(path: path, pathArgs: pathArgs, parameters: parameters)

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
        
        let parameters = [Parameter(parameter: Parameters.language), Parameter(parameter: Parameters.api_key)]
        
        let pathArgs = "\(mediaId!)/credits"

        let url = MediaUrl(path: path, pathArgs: pathArgs, parameters: parameters)

        webClient.request(url: fillMediaUrl(url: url)) { (webResponse) in
           onComplete(MediaCredits(json: webResponse.json!), webResponse)
        }
    }
    
            
}
