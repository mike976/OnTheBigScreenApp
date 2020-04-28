//
//  MoviesNowPlayingViewModel.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 28/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

protocol MoviesNowPlayingViewModelProtocol {

    var moviesNowPlayingReceivedDelegate: MoviesNowPlayingReceivedDelegate! { get }
    func getMoviesNowPlaying ()
}

class MoviesNowPlayingViewModel : MoviesNowPlayingViewModelProtocol {
    
    private var movieService: MoviesService

    var moviesNowPlayingList: MovieResults! {
        didSet {
            self.moviesNowPlayingReceivedDelegate?.moviesNowPlayingReceived()
        }
    }
    
    var moviesNowPlayingReceivedDelegate: MoviesNowPlayingReceivedDelegate!
    
    required init(movieService: MoviesService) {

        self.movieService = movieService
        self.movieService.moviesNowPlayingReceivedDelegate = self
    }
        
    func getMoviesNowPlaying () {
        
        self.movieService.getMoviesNowPlaying()
    }
    
}

extension MoviesNowPlayingViewModel : MoviesNowPlayingReceivedDelegate {
    
    func moviesNowPlayingReceived() {
        if let moviesNowPlaying = self.movieService.moviesNowPlayingList {
            
//            print("received movies in MoviewNowPlayingViewModel \(moviesNowPlaying)")

            self.moviesNowPlayingList = moviesNowPlaying
            
        }
    }
}




