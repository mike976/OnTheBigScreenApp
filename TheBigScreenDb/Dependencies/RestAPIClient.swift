

import Foundation
//import AlamofireImage


protocol RestApiClientProtocol {
    
    typealias completionHandler<T:Codable> = (Result<T, RestApiError>) -> Void
    func GetRequest<T : Codable>(url: URL, completion: @escaping completionHandler<T>)
}


enum RestApiError : Error {
    case noDataAvailable
    case unableToDecode    
}

class RestAPIClient : RestApiClientProtocol {
    

    typealias completionHandler<T:Codable> = (Result<T, RestApiError>) -> Void
    
    func GetRequest<T : Codable>(url: URL, completion: @escaping completionHandler<T>) {
        
        //1. create request
        //2. call request
        //3. check response fail and return completionhandler failur3
        //4. create jsondecoder and do try decode response data
        //5. create decodable object and return completionhandler success
            
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                           
            guard error == nil else {
                print ("error getting response: \(error!)")
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }

           
            let decoder = JSONDecoder()
            
            do {
                let codableResponse = try decoder.decode(T.self, from: jsonData)
                
                completion(.success(codableResponse))
                return
                
            } catch {
                completion(.failure(.unableToDecode))
            }
        }
        
        dataTask.resume()
            
    }
}
