//
//  NetworkManager.swift
//  On the Map
//
//  Created by Laxman Nyamagouda on 4/25/20.
//  Copyright © 2020 Laxman Nyamagouda. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case FoundNil(String)
    case Success(String)
}


let studentLocationURL = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
let postStudentLocationURL = "https://onthemap-api.udacity.com/v1/StudentLocation"

class NetworkMananger {
    
    // MARK: - Singleton
    static let shared: NetworkMananger = {
          let instance = NetworkMananger()
          return instance
      }()
    
    func getStudentLocations(completion: @escaping (_ result: [StudentLocationsResponse]?, _ success: Bool, _ error: String?) -> Void){
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion(nil, false, "Error in Network")
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                _ = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (nil, false,"")
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                
                guard let array = resultsArray else {return}
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                let locations = try! JSONDecoder().decode([StudentLocationsResponse].self, from: dataObject)
                completion (locations, true, nil)
            }
        }
        task.resume()
    }
    
    func postStudentLocation(_ location: StudentLocationsResponse, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, "error")
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                _ = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false,"")
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {
                    completion (false, "error")
                    return
                }
                print(jsonDictionary)
                completion (true, nil)
            } else {
                completion(false, "error" )
            }
        }
        task.resume()
    }
    
    func logInWithUdacityCredentials(_ userNAme: String, _ password: String, completionHandler:@escaping (_ result: LogInResponse?, _ error: Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(userNAme)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            let range: CountableRange = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            guard let dataResponse = newData,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completionHandler(nil, error)
                    return }
            do {
                if let model = try? JSONDecoder().decode(LogInResponse.self, from: dataResponse) {
                    completionHandler(model, nil)
                    return
                } else {
                    throw NetworkError.FoundNil("Unable to map dataResponse to Object Model")
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    
    func logout(completion: @escaping (_ success: Bool)->())  {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (false)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async {
                completion(true)
            }
        }
        task.resume()
    }
    
    func getPublicUserData() {
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
          let range: CountableRange = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}
