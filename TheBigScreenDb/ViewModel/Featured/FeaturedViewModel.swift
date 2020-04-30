//
//  FeaturedViewModel.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 28/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit
import Foundation

protocol FeaturedViewModelProtocol {
     
    typealias getNowPlayingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getNowPlayingMovies(page : Int, onComplete : @escaping getNowPlayingMoviesOnComplete)
    
    typealias getUpcomingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getUpcomingMovies(page: Int, onComplete : @escaping getUpcomingMoviesOnComplete)
    
    typealias getTrendingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getTrendingMovies(page: Int, onComplete : @escaping getTrendingMoviesOnComplete)
    
}

class FeaturedViewModel : FeaturedViewModelProtocol {
    
    deinit {
        print("OS reclaiming memory - FeaturedViewModel - no retain cycle/memory leaks here")
    }
        
    private var moviesNowPlayingViewModel: NowPlayingViewModel
    
    
    var featuredHeaderImages: [UIImage] {

        get {
            let x = [  UIImage(named:"FeaturedHeaderImage1")!,
            UIImage(named:"FeaturedHeaderImage2")! ,
            UIImage(named:"FeaturedHeaderImage3")! ,
            UIImage(named:"FeaturedHeaderImage4")! ,
            UIImage(named:"FeaturedHeaderImage5")! ,
            UIImage(named:"FeaturedHeaderImage6")!
            ]
            
            return x
        }
            
    }
    

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
    
    typealias getUpcomingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getUpcomingMovies(page : Int = 1, onComplete : @escaping getUpcomingMoviesOnComplete){

        self.moviesNowPlayingViewModel.getUpcomingMovies(page: page)  { (movies, webResponse) in
            if !webResponse.isError{
                onComplete(movies, webResponse)
            }
        }
    }
    
    typealias getTrendingMoviesOnComplete = ([Movie], WebResponse) -> Void
    func getTrendingMovies(page : Int = 1, onComplete : @escaping getTrendingMoviesOnComplete){

        self.moviesNowPlayingViewModel.getTrendingMovies(page: page)  { (movies, webResponse) in
            if !webResponse.isError{
                onComplete(movies, webResponse)
            }
        }
    }
}
