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
    func getMethod(_ method:String,parameters:[String:AnyObject], completionHandlerForGET: @escaping (_ response : Any?, _ error :Error?) -> Void)
    {
        let url = CryptoExchangeURLFromParameters(parameters as [String : AnyObject], withPathExtension: method)
        Alamofire.request(String(describing: url)).responseJSON { response in switch response.result {
        case .success(let JSON):
            let response = JSON as! NSDictionary
            let array = response.object(forKey: method.substring(from: method.index(after: method.startIndex)))! as! NSArray
            completionHandlerForGET(array,nil)
        case .failure(let error):
            print("Request failed with error: \(error)")
            }
        }
        
    }
    
//    func getMethodCall(_ method:String,parameters:[String:AnyObject], completionHandlerForGET: @escaping (_ response : Any?, _ error :Error?) -> Void)
//    {
//        let url = CryptoExchangeURLFromParameters(parameters as [String : AnyObject], withPathExtension: method)
//        Alamofire.request(String(describing: url)).responseJSON { response in switch response.result {
//        case .success(let JSON):
//            let response = JSON as! NSDictionary
//            completionHandlerForGET(response,nil)
//        case .failure(let error):
//            print("Request failed with error: \(error)")
//            }
//        }
//    }
    
    func postMethod(_ method:String, parameters:[String:AnyObject], completionHandlerForPost: @escaping (_ respose: NSDictionary?, _ error : Error?) -> Void) {
        let url = CryptoExchangeURLFromParameters([:], withPathExtension: method)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (responseObj) in
            switch responseObj.result{
            case .success(let json):
                guard let response = json as? NSDictionary else {
                    completionHandlerForPost(nil, nil)
                    return
                }
                guard let statusCode = response["statusCode"] as? Int, statusCode >= 200 && statusCode <= 299 else {
                    print("Your request returned a status code other than 2xx!")
                    print(response["message"] ?? "error message")
                    completionHandlerForPost(nil, nil)
                    return
                }
                completionHandlerForPost(response, nil)
            case .failure(let error):
                completionHandlerForPost(nil,error)
            }
        }
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
