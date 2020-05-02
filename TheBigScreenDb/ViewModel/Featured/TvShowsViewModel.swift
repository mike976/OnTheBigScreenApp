

import Foundation


protocol TvShowsViewModelProtocol {
    
    func getTvShowsAsync(page : Int, endpoint: TvShowEndPont) -> [TvShow]?
}


class TvShowsViewModel : TvShowsViewModelProtocol{
    

    //MARK: - private proprties
    private var movieDatabaseService: TheMovieDatabaseServiceProtocol!

    //MARK: - Initializers
    required init(movieDatabaseService: TheMovieDatabaseServiceProtocol) {

        self.movieDatabaseService = movieDatabaseService
    }
    
    //MARK: - Public Functions

    // Async-Await Task
    func getTvShowsAsync(page : Int = 1, endpoint: TvShowEndPont) -> [TvShow]? {

        var tvShows:[TvShow]? = nil

        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {

            self.movieDatabaseService.getTvShows(page: page, path: endpoint)  { (tvShowsList, webResponse) in
                if !webResponse.isError{
                    tvShows = tvShowsList
                } else {
                    print("TvShowsViewModel - getTvShowsAsync - \(endpoint) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                }
                
                semaphore.signal()
            }
        }
        
        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
        
        return tvShows
    }
}
