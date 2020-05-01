//
//  MoviesNowPlayingViewModel.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 28/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//
import UIKit
import Foundation

protocol MoviesViewModelProtocol {

    func getMoviesAsync(page : Int, endpoint: MovieEndPoint) -> [Movie]?
}

class MoviesViewModel : MoviesViewModelProtocol {
        
    //MARK: - Destructor
    deinit {
        print("OS reclaiming memory - MoviesNowPlayingViewModel - no retain cycle/memory leaks here")
    }
    
    //MARK: - private proprties
    private var movieDatabaseService: TheMovieDatabaseService
    
    
    //MARK: - Public Properties
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
    
    //MARK: - Initializers
    required init(movieDatabaseService: TheMovieDatabaseService) {

        self.movieDatabaseService = movieDatabaseService
    }
            
    
    //MARK: - Public Functions

    // Async-Await Task
    func getMoviesAsync(page : Int = 1, endpoint: MovieEndPoint) -> [Movie]? {

        var movies:[Movie]? = nil

        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {

            self.movieDatabaseService.getMovies(page: page, path: endpoint)  { (moviesList, webResponse) in
                if !webResponse.isError{
                    movies = moviesList
                } else {
                    print("MoviesViewModel - getMovies - \(endpoint) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                }
                
                semaphore.signal()
            }
        }
        
        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
        
        return movies
    }
}




