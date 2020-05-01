//
//  MoviesNowPlayingViewModel.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 28/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

protocol NowPlayingViewModelProtocol {

    func getMoviesAsync(page : Int, endpoint: MovieEndPoint) -> [Movie]?
}

class NowPlayingViewModel : NowPlayingViewModelProtocol {
    
    
    deinit {
        print("OS reclaiming memory - MoviesNowPlayingViewModel - no retain cycle/memory leaks here")
    }
    
    private var movieService: MoviesService
    
    required init(movieService: MoviesService) {

        self.movieService = movieService
    }
            
    
    // Async-Await Task
    func getMoviesAsync(page : Int = 1, endpoint: MovieEndPoint) -> [Movie]? {

        var movies:[Movie]? = nil

        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {

            self.movieService.getMovies(page: page, path: endpoint)  { (moviesList, webResponse) in
                if !webResponse.isError{
                    movies = moviesList
                } else {
                    print("NowPlayingViewModel - getMovies - \(endpoint) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                }
                
                semaphore.signal()
            }
        }
        
        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
        
        return movies
    }
}




