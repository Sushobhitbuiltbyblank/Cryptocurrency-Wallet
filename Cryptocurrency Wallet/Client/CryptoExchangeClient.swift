//
//  CryptoExchangeClient.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit Jain on 05/08/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import UIKit
import Alamofire

class CryptoExchangeClient: NSObject {

    // MARK: Properties
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }

    // MARK: GET
//    func getMethod(_ method:String,parameters:[String:AnyObject], completionHandlerForGET: @escaping (_ response : Any?, _ error :Error?) -> Void)
//    {
//        let url = CryptoExchangeURLFromParameters(parameters as [String : AnyObject], withPathExtension: method)
//        Alamofire.request(String(describing: url)).responseJSON { response in switch response.result {
//        case .success(let JSON):
//            let response = JSON as! NSDictionary
//            let array = response.object(forKey: method.substring(from: method.index(after: method.startIndex)))! as! NSArray
//            completionHandlerForGET(array,nil)
//        case .failure(let error):
//            print("Request failed with error: \(error)")
//            }
//        }
//        
//    }
    
    func getMethodCall(_ method:String,parameters:[String:AnyObject], completionHandlerForGET: @escaping (_ response : Any?, _ error :Error?) -> Void)
    {
        let url = CryptoExchangeURLFromParameters(parameters as [String : AnyObject], withPathExtension: method)
        Alamofire.request(String(describing: url)).responseJSON { response in switch response.result {
        case .success(let JSON):
            let response = JSON as! NSDictionary
            completionHandlerForGET(response,nil)
        case .failure(let error):
            print("Request failed with error: \(error)")
            }
        }
    }
    
    // MARK: POST
//    func postMethodCall(_ method:String, parameters:[String:AnyObject], completionHandlerForPost: @escaping (_ respose: NSDictionary?, _ error : Error?) -> Void) {
//        let url = CryptoExchangeURLFromParameters([:], withPathExtension: method)
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data", forHTTPHeaderField: "enctype")
//        Alamofire.upload(multipartFormData: { (formData) in
//            if parameters[Constants.JSONUserRequestKey.avatar] != nil {
//                formData.append(parameters[Constants.JSONUserRequestKey.avatar] as! URL, withName: Constants.JSONUserRequestKey.avatar, fileName: Constants.Image.profilePic, mimeType: "image/jpeg")
//            }
//            for (key, value) in parameters {
//                if key != Constants.JSONUserRequestKey.avatar {
//                    if value is String || value is Int {
//                        formData.append("\(value)".data(using: .utf8)!, withName: key)
//                    }
//                }
//            }
//        }, with: request) { (result) in switch result {
//        case .success(let upload, _, _):
//            upload.uploadProgress(closure: { (progress) in
//                print(progress)
//            })
//            upload.responseJSON { response in
//                print(response)
//                if(response.result.value != nil) {
//                    let result = response.result.value as! NSDictionary
//                    completionHandlerForPost(result, nil)
//                }
//                else{
//                    print("error again")
//                }
//            }
//        case .failure(let encodingError):
//            print(encodingError.localizedDescription)
//            completionHandlerForPost(nil,encodingError)
//            }
//        }
//        
//    }
    
    func postMethod(_ method:String, parameters:[String:AnyObject], completionHandlerForPost: @escaping (_ respose: NSDictionary?, _ error : Error?) -> Void) {
        let url = CryptoExchangeURLFromParameters([:], withPathExtension: method)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let parameter = ["password":"jafarnaqvi",
        "email":"jafar@darwinlabs.io"]
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.httpBody).responseJSON { (response) in
            print(response)
        }
//        Alamofire.upload(multipartFormData: { (formData) in
//        for (key, value) in parameters {
//                if value is String || value is Int {
//                    formData.append("\(value)".data(using: .utf8)!, withName: key)
//                }
//            }
//        }, with: request) { (result) in switch result {
//        case .success(let upload, _, _):
//            upload.responseJSON { response in
//                print(response)
//                
//                if let result = response.result.value as? NSDictionary
//                {
//                    print(result.value(forKey: "status") as! Bool)
//                    completionHandlerForPost(result, nil)
//                }
//                else{
//                    completionHandlerForPost(nil, nil)
//                }
//            }
//        case .failure(let encodingError):
//            print(encodingError.localizedDescription)
//            completionHandlerForPost(nil,encodingError)
//            }
//        }
        
    }
   
    // MARK: Helpers
    
    
    // given raw JSON, return a usable Foundation object
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult as AnyObject?, nil)
    }
    
    // create a URL from parameters
    fileprivate func CryptoExchangeURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
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
        
        return components.url! as URL
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> CryptoExchangeClient {
        struct Singleton {
            static var sharedInstance = CryptoExchangeClient()
        }
        return Singleton.sharedInstance
    }
    
}
