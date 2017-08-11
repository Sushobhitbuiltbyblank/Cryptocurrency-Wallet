//
//  CrptoExchangeConvenience.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit Jain on 05/08/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import Foundation

extension CryptoExchangeClient {
    
    func register(_ parameters:[String:AnyObject], completionHandlerForResigter:@escaping (_ response:NSDictionary?, _ error:Error?)->Void)
    {
        let mutableMethod:String = Methods.userRegister
        postMethod(mutableMethod, parameters: parameters) {
            (response, error) in
            if error == nil {
                completionHandlerForResigter(response,error)
            }
            else{
                completionHandlerForResigter(nil,error)
            }
        }
    }
    
    func login(_ parameters:[String:AnyObject], completionHandlerForLogin:@escaping (_ response:NSDictionary?, _ error:Error?)->Void)
    {
        let mutableMethod:String = Methods.userLogin
        postMethod(mutableMethod, parameters: parameters) {
            (response, error) in
            print(response ?? "no response")
            if error == nil {
                completionHandlerForLogin(response,error)
            }
            else{
                completionHandlerForLogin(nil,error)
            }
        }
    }
    
    func getEthereumWallet(_ parameters:[String:AnyObject], completionHandlerForEthereumWallet:@escaping (_ response:NSDictionary?, _ error:Error?)->Void)
    {
        let mutableMethod:String = Methods.getEthereumWallet
        getMethod(mutableMethod, parameters: [:]) { (response, error) in
            if error == nil {
                completionHandlerForEthereumWallet(response as? NSDictionary,error)
            }
            else{
                completionHandlerForEthereumWallet(nil,error)
            }
        }
    }
    
    
}
