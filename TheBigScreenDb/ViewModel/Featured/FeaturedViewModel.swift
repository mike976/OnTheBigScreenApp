//
//  FeaturedViewModel.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 28/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

protocol FeaturedViewModelProtocol {
    var moviesNowPlayingReceivedDelegate: MoviesNowPlayingReceivedDelegate! { get }
    func getMoviesNowPlaying ()
}

class FeaturedViewModel : FeaturedViewModelProtocol {
        
    private var moviesNowPlayingViewModel: MoviesNowPlayingViewModel
    
    var moviesNowPlayingList: MovieResults! {
        didSet {
            self.moviesNowPlayingReceivedDelegate?.moviesNowPlayingReceived()
        }
    }

    var moviesNowPlayingReceivedDelegate: MoviesNowPlayingReceivedDelegate!

    required init(moviesNowPlayingViewModel: MoviesNowPlayingViewModel) {
        
        self.moviesNowPlayingViewModel = moviesNowPlayingViewModel
        self.moviesNowPlayingViewModel.moviesNowPlayingReceivedDelegate = self
    }
    
    func getMoviesNowPlaying () {
        
        self.moviesNowPlayingViewModel.getMoviesNowPlaying()
    }
    
}

extension FeaturedViewModel : MoviesNowPlayingReceivedDelegate {
    
    func moviesNowPlayingReceived() {
        if let moviesNowPlaying = self.moviesNowPlayingViewModel.moviesNowPlayingList {
            //print("received movies in FeaturedViewModel \(moviesNowPlaying)")
            self.moviesNowPlayingList = moviesNowPlaying
        }
    }
}





