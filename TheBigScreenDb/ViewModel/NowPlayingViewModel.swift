//
//  MoviesNowPlayingViewModel.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 28/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

protocol NowPlayingViewModelProtocol {

    typealias getNowPlayingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getNowPlayingMovies(page : Int, onComplete : @escaping getNowPlayingMoviesOnComplete)
}

class NowPlayingViewModel : NowPlayingViewModelProtocol {
    
    
    deinit {
        print("OS reclaiming memory - MoviesNowPlayingViewModel - no retain cycle/memory leaks here")
    }
    
    private var movieService: MoviesService
    
    required init(movieService: MoviesService) {

        self.movieService = movieService
    }
        
        
    typealias getNowPlayingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getNowPlayingMovies(page : Int = 1, onComplete : @escaping getNowPlayingMoviesOnComplete){

        self.movieService.getNowPlayingMovies(page: page)  { (movies, webResponse) in
            if !webResponse.isError{

                onComplete(movies, webResponse)
            }        
        }
    }
}




