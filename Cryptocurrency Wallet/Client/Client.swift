//
//  Client.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit_BuiltByBlank on 8/7/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import UIKit
import Alamofire

class Client: NSObject {
    var session = URLSession.shared
    
    // configuration object
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: POST
    func postMethod(_ method:String, parameters:[String:AnyObject], completionHandlerForPost: @escaping (_ respose: NSDictionary?, _ error : Error?) -> Void) {
        let urlstr = "http://139.59.27.120:8080/login/"
        let url = URL(string: urlstr)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let newTodo: [String: Any] = ["password": "jafarnaqvi", "email": "jafar@darwinlabs.io"]
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            request.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
//        let jsonBody = "{\"password\": \"jafarnaqvi\",\"email\": \"jafar@darwinlabs.io\"}"
//        let d = jsonBody.data(using: String.Encoding.utf8
        let task =  session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                //                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            do {
                guard let todo = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                completionHandlerForPost(todo as NSDictionary, nil)
            } catch  {
                    print("error trying to convert data to JSON")
                    return
            }

        }
        
        task.resume()
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult as AnyObject, nil)
    }
    
    // create a URL from parameters
    fileprivate func tmdbURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Crytocurrency.ApiScheme
        components.host = Crytocurrency.ApiHost
        components.port = Crytocurrency.ApiPort
        components.path = Crytocurrency.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }

}
