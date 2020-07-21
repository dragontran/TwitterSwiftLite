import Foundation
import FoundationNetworking

enum Requests {
  static func get<T: Codable>(urlString: String, completionHandler: ((T) -> Void)? = nil) {
    guard let url = URL(string: urlString) else {
      return
    }
    
    let group = DispatchGroup()
    group.enter()

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      defer {
        group.leave()
      }
      guard 
        let data = data,
        let result = try? JSONDecoder().decode(T.self, from: data) 
      else { 
        fatalError("error")
      }

      completionHandler?(result)
    }

    task.resume()
    group.wait()
  } 

  static func post(urlRequest: URLRequest) {
    let group = DispatchGroup()
    group.enter()

    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      defer {
        group.leave()
      }

      if let error = error {
        print("error: \(error)")
      }
      if let response = response as? HTTPURLResponse {
        print("statusCode: \(response.statusCode)")
      }
      if let data = data, let dataString = String(data: data, encoding: .utf8) {
        print("data: \(dataString)")
      }
    }

    task.resume()
    group.wait()
  }
}