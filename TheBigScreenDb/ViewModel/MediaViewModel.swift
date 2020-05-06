

import Foundation

protocol MediaViewModelProtocol {
    
    func getMediaListAsync<T: MediaProtocol>(page : Int, endpoint: MediaEndpoint, _ searchQuery: String?) -> [T]?
    
    func getMediaDetailAsync(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?) -> MediaDetail?
   
    func getMediaCreditsAsync(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?) -> MediaCredits?
}

class MediaViewModel : MediaViewModelProtocol {
    
    //MARK: - Destructor
    deinit {
        print("OS reclaiming memory - MediaViewModel - no retain cycle/memory leaks here")
    }
    
    //MARK: - private proprties
    private var movieDatabaseService: TheMovieDatabaseServiceProtocol!
        
    
    //MARK: - Initializers
    required init(movieDatabaseService: TheMovieDatabaseServiceProtocol) {
        
        self.movieDatabaseService = movieDatabaseService
    }
    
    
    //MARK: - Public Functions
    
    // Async-Await Task
    func getMediaListAsync<T: MediaProtocol>(page : Int = 1, endpoint: MediaEndpoint, _ searchQuery: String?) -> [T]? {
        
        var mediaList:[T]? = nil

        let semaphore = DispatchSemaphore(value: 0)

        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async {
               
            self.movieDatabaseService.getMediaList(page: page, path: endpoint, searchQuery: searchQuery)  { (mediaResults: [T], webResponse) in

                if !webResponse.isError{
                    mediaList = mediaResults
                } else {
                    print("MediaListViewModel - getMediaListAsync - \(endpoint) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                }

                semaphore.signal()
            }
        }

        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
                    
        return mediaList
               
    }
    
    // Async-Await Task
    func getMediaDetailAsync(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?) -> MediaDetail? {
        
        var mediaDetail:MediaDetail? = nil

        let semaphore = DispatchSemaphore(value: 0)

        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async {
               
            self.movieDatabaseService.getMediaDetail(path: path, mediaType: mediaType, mediaId: mediaId)  { (mediaResult, webResponse) in

                if !webResponse.isError{
                    mediaDetail = mediaResult
                } else {
                    print("MediaViewModel - getMediaDetailAsync - \(path) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                }

                semaphore.signal()
            }
        }

        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
                    
        return mediaDetail
               
    }
    
    // Async-Await Task
    func getMediaCreditsAsync(path: MediaEndpoint, mediaType: MediaType, mediaId: Int?) -> MediaCredits? {
        
        var mediaCredits:MediaCredits? = nil

        let semaphore = DispatchSemaphore(value: 0)

        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async {
               
            self.movieDatabaseService.getMediaCredits(path: path, mediaType: mediaType, mediaId: mediaId)  { (mediaResult, webResponse) in

                if !webResponse.isError{
                    mediaCredits = mediaResult
                } else {
                    print("MediaViewModel - getMediaCreditsAsync - \(path) - Error:", webResponse.error?.localizedDescription ?? "no error description found")
                }

                semaphore.signal()
            }
        }

        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
                    
        return mediaCredits
               
    }
}



