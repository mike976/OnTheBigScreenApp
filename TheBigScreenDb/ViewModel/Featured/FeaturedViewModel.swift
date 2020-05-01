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
     
    func getMoviesAsync(page: Int, endpoint: MovieEndPoint) -> [Movie]?
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
    
    // Async-Await Task
    func getMoviesAsync(page : Int = 1, endpoint: MovieEndPoint) -> [Movie]? {

        var movies: [Movie]?
        
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)
                
        dispatchQueue.async {
            movies = self.moviesNowPlayingViewModel.getMoviesAsync(page: page, endpoint: endpoint)
            semaphore.signal()
        }
        
        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)

        
        return movies
    }
}
