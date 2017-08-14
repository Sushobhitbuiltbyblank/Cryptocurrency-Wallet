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
    func getMethod(_ method:String,parameters:[String:AnyObject],headers:[String:String], completionHandlerForGET: @escaping (_ response : Any?, _ error :Error?) -> Void)
    {
        let url = CryptoExchangeURLFromParameters(parameters as [String : AnyObject], withPathExtension: method)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                completionHandlerForGET(response,nil)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    // MARK: POST
    func postMethod(_ method:String, parameters:[String:AnyObject], headers:[String:String], completionHandlerForPost: @escaping (_ respose: NSDictionary?, _ error : Error?) -> Void) {
        let url = CryptoExchangeURLFromParameters([:], withPathExtension: method)
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default , headers: headers).responseJSON { (responseObj) in
            switch responseObj.result{
            case .success(let json):
                guard let response = json as? NSDictionary else {
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
