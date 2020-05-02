

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
    private var movieDatabaseService: TheMovieDatabaseServiceProtocol!
        
    
    //MARK: - Initializers
    required init(movieDatabaseService: TheMovieDatabaseServiceProtocol) {
        
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




