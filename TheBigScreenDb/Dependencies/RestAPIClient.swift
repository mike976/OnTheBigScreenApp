

import Foundation
import Alamofire
//import SwiftyJSON
//import AlamofireImage


class RestAPIClient {
    
    typealias completionHandler<T : Codable> = (T?, Error?) -> Void
    
    func Get<T : Codable> (_ url: URL, completion: @escaping completionHandler<T>) {
        
        AF.request(url, method: .get).validate().responseJSON { (response) in
                                            
            if let error = response.error {
                completion(nil, error)
            } else if let safeData = response.data {
                                
                let decoder = JSONDecoder()
                                
                do {
                    let TData = try decoder.decode(T.self, from: safeData)
                    completion(TData, nil)
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                // LOOK AT THE EXAMPLE in t.downloadhis link maybe for image downloading
                //https://www.raywenderlich.com/35-alamofire-tutorial-getting-started
                
                //let swiftyJsonVar = JSON(response.value!)
                
                
                //                if let resArray = swiftyJsonVar.arrayObject {
                //                   completion(resArray as? [[String:Any]], nil)
                //
                //                   print("Array")
                //
                //                } else if let resDict = swiftyJsonVar.dictionaryObject {
                //                    completion([resDict], nil)
                //
                //                    print("Dictionary")
                //                }
            }
        }
    }
}

struct Post : Codable {
    var userId: Int
    var id: Int
    var title : String
    var body : String
}
