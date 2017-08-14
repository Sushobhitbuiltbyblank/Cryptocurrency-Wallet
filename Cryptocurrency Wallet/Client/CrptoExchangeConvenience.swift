//
//  CrptoExchangeConvenience.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit Jain on 05/08/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import Foundation
import KeychainSwift

extension CryptoExchangeClient {
    
    func register(_ parameters:[String:AnyObject], completionHandlerForResigter:@escaping (_ response:NSDictionary?, _ error:Error?)->Void)
    {
        let mutableMethod:String = Methods.userRegister
        postMethod(mutableMethod, parameters: parameters, headers: [:]){
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
        postMethod(mutableMethod, parameters: parameters, headers: [:]) {
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
        let keychain = KeychainSwift()
        let token = keychain.get(UserResponseKey.token)
        let headers = ["x-access-token":token]
        getMethod(mutableMethod, parameters: [:], headers: headers as! [String : String]) { (response, error) in
            if error == nil {
                completionHandlerForEthereumWallet(response as? NSDictionary,error)
            }
            else{
                completionHandlerForEthereumWallet(nil,error)
            }
        }
    }
    
    func creatWallet(_ parameters:[String:AnyObject], completionHandlerForCreateWallet:@escaping (_ response:NSDictionary?, _ error:Error?)->Void)
    {
        let mutableMethod:String = Methods.createEthereumWallet
        
        let keychain = KeychainSwift()
        let token = keychain.get(UserResponseKey.token)
        let headers = ["x-access-token":token]
        postMethod(mutableMethod, parameters: [:], headers: headers as! [String : String]) { (reponse, error) in
            if error == nil {
                completionHandlerForCreateWallet(reponse,error)
            }
            else{
                completionHandlerForCreateWallet(nil,error)
            }
        }

    }
    
    func getEthereumTransactionHistory(_ parameters:[String:AnyObject], completionHandlerForEthereumWallet:@escaping (_ response:NSDictionary?, _ error:Error?)->Void)
    {
        let mutableMethod:String = Methods.getEthereumTransactionHistory
        let keychain = KeychainSwift()
        let token = keychain.get(UserResponseKey.token)
        let headers = ["x-access-token":token]
        getMethod(mutableMethod, parameters: [:], headers: headers as! [String : String]) { (response, error) in
            if error == nil {
                completionHandlerForEthereumWallet(response as? NSDictionary,error)
            }
            else{
                completionHandlerForEthereumWallet(nil,error)
            }
        }
    }

    
}
