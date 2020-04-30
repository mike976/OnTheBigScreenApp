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
    func getNowPlayingMovies(page: Int, onComplete : @escaping getNowPlayingMoviesOnComplete)
    
    typealias getUpcomingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getUpcomingMovies(page: Int, onComplete : @escaping getUpcomingMoviesOnComplete)
    
    typealias getTrendingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getTrendingMovies(page : Int, onComplete : @escaping getTrendingMoviesOnComplete)
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

        self.movieService.getMovies(page: page, path: MoviesService.Path.nowplaying_movies)  { (movies, webResponse) in
            if !webResponse.isError{
                onComplete(movies, webResponse)
            }        
        }
    }
    
    typealias getUpcomingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getUpcomingMovies(page : Int = 1, onComplete : @escaping getUpcomingMoviesOnComplete){

        self.movieService.getMovies(page: page, path: MoviesService.Path.upcoming_movies)  { (movies, webResponse) in
            if !webResponse.isError{
                onComplete(movies, webResponse)
            }
        }
    }
    
    typealias getTrendingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getTrendingMovies(page : Int = 1, onComplete : @escaping getTrendingMoviesOnComplete){

        self.movieService.getMovies(page: page, path: MoviesService.Path.trending_movies)  { (movies, webResponse) in
            if !webResponse.isError{
                onComplete(movies, webResponse)
            }
        }
    }
}




