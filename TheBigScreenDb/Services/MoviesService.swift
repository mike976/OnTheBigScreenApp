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
    //MARK: - return list of movies in the spotlight
    //MARK: - return list of movies Trending
    //MARK: - return list of movies in the Coming Soon
    //MARK: - return list of movies By Search
    //MARK: - return Movie
    //MARK: - return Cast Member
}


protocol MoviesNowPlayingReceivedDelegate {
    
    func moviesNowPlayingReceived()
}

enum MovieEndpoints : String {
    case now_playing = "now_playing?"
}

class MoviesService : MoviesServiceProtocol {
    
    private let apiKey = "?api_key=5cd88ad1ae9b1b0d53d5e8467fe9c9bb"
    private let language = "&language=en-US"
    private let baseUrl = "https://api.themoviedb.org/3/movie"
    
    let restApiClient = RestAPIClient()
        
    var moviesNowPlayingReceivedDelegate: MoviesNowPlayingReceivedDelegate?
    
    var moviesNowPlayingList: MovieResults?
    
    func getMoviesNowPlaying () {

        /*
         1. form url
         2. call restapi
         3. ensure we have collection of movie models that we return
         */
        
        let url = URL(string: "\(baseUrl)/\(MovieEndpoints.now_playing)\(apiKey)\(language)")!
        
        restApiClient.GetRequest(url: url, completion: { [weak self] (result: Result<MovieResults, RestApiError> ) in
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let result):
                self?.moviesNowPlayingList = result
                self?.moviesNowPlayingReceivedDelegate?.moviesNowPlayingReceived()
            }
            
        })
    }    
}
