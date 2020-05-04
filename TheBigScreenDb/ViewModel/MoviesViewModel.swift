

import Foundation

protocol MediaListViewModelProtocol {
    
    func getMediaListAsync(page : Int, endpoint: MediaEndpoint) -> [Media]?
}

class MediaListViewModel : MediaListViewModelProtocol {
    
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
    func getMediaListAsync(page : Int = 1, endpoint: MediaEndpoint) -> [Media]? {
        
        var mediaList:[Media]? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {
            
            self.movieDatabaseService.getMediaList(page: page, path: endpoint)  { (mediaResults, webResponse) in
                if !webResponse.isError{
                    mediaList = mediaResults
                } else {
                    print("MoviesViewModel - getMediaList - \(endpoint) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                }
                
                semaphore.signal()
            }
        }
        
        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
        
        return mediaList
    }
}




