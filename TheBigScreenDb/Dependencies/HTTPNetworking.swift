
import Foundation

// 1.
protocol Networking {
  
  typealias CompletionHandler = (Data?, Swift.Error?) -> Void
  func request(from: Endpoint, completion: @escaping CompletionHandler)
}

// 2.
struct HTTPNetworking: Networking {
  
  // 3.
  func request(from: Endpoint, completion: @escaping CompletionHandler) {
    guard let url = URL(string: from.path) else { return }
    let request = createRequest(from: url)
    let task = createDataTask(from: request, completion: completion)
    task.resume()
  }
  
  // 4.
  private func createRequest(from url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.cachePolicy = .reloadIgnoringCacheData
    return request
  }
  
  // 5.
  private func createDataTask(from request: URLRequest,
                              completion: @escaping CompletionHandler) -> URLSessionDataTask {
    return URLSession.shared.dataTask(with: request) { data, httpResponse, error in
      completion(data, error)
    }
  }
}
