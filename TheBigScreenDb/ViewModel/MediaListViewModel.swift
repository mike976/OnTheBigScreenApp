

import Foundation

protocol MediaListViewModelProtocol {
    
    func getMediaListAsync<T: MediaProtocol>(page : Int, endpoint: MediaEndpoint) -> [T]?
}

class MediaListViewModel : MediaListViewModelProtocol {
    
    //MARK: - Destructor
    deinit {
        print("OS reclaiming memory - MediaListViewModel - no retain cycle/memory leaks here")
    }
    
    //MARK: - private proprties
    private var movieDatabaseService: TheMovieDatabaseServiceProtocol!
        
    
    //MARK: - Initializers
    required init(movieDatabaseService: TheMovieDatabaseServiceProtocol) {
        
        self.movieDatabaseService = movieDatabaseService
    }
    
    
    //MARK: - Public Functions
    
    // Async-Await Task
    func getMediaListAsync<T: MediaProtocol>(page : Int = 1, endpoint: MediaEndpoint) -> [T]? {

        var mediaList:[Media]? = nil

        let semaphore = DispatchSemaphore(value: 0)

        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async {
            
            if endpoint == .trending_tvshows {
                
                self.movieDatabaseService.getMediaList(page: page, path: endpoint)  { (mediaResults: [TvShow], webResponse) in

                    if !webResponse.isError{
                        mediaList = mediaResults //as! [TvShow]
                    } else {
                        print("MediaListViewModel - getMediaList - \(endpoint) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                    }

                    semaphore.signal()
                }
                
            } else {

                self.movieDatabaseService.getMediaList(page: page, path: endpoint)  { (mediaResults: [Movie], webResponse) in

                    if !webResponse.isError{
                        mediaList = mediaResults //as! [Movie]
                    } else {
                        print("MediaListViewModel - getMediaList - \(endpoint) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                    }

                    semaphore.signal()
                }
                
            }

        }

        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
                    
        return mediaList as? [T]
               
    }
}



