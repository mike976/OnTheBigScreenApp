//
//  FeaturedViewModel.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 28/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

protocol FeaturedViewModelProtocol {
     
    typealias getNowPlayingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getNowPlayingMovies(page : Int, onComplete : @escaping getNowPlayingMoviesOnComplete)
    
}

class FeaturedViewModel : FeaturedViewModelProtocol {
    
    deinit {
        print("OS reclaiming memory - FeaturedViewModel - no retain cycle/memory leaks here")
    }
        
    private var moviesNowPlayingViewModel: NowPlayingViewModel
    

    required init(moviesNowPlayingViewModel: NowPlayingViewModel) {
        
        self.moviesNowPlayingViewModel = moviesNowPlayingViewModel
    }
        
    typealias getNowPlayingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getNowPlayingMovies(page : Int = 1, onComplete : @escaping getNowPlayingMoviesOnComplete){

        self.moviesNowPlayingViewModel.getNowPlayingMovies(page: page)  { (movies, webResponse) in
            if !webResponse.isError{

                onComplete(movies, webResponse)
            }
        }
    }    
}
