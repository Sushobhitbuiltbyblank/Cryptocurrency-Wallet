//
//  CWLoginVC.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit_BuiltByBlank on 8/10/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import UIKit
import SVProgressHUD
import KeychainSwift

class CWLoginVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapToHideKeyboard()
        assignTFDelegate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignTFDelegate()
    {
        self.passwordTF.delegate = self
        self.emailTF.delegate = self
    }
    
    func isValide()->Bool
    {
        if (self.passwordTF.text?.isEmpty)!
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in password", viewController: self)
            return false
        }
        if (self.emailTF.text?.isEmpty)!
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in your email address", viewController: self)
            return false
        }
        if !Validator.sharedInstance.isValidEmail(testStr: self.emailTF.text!)
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in valid email address", viewController: self)
            return false
        }
        if Validator.sharedInstance.isStringlessthanLength(str: self.passwordTF.text!, len: 8)
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in password minimum of 8", viewController: self)
            return false
        }

        return true
    }
    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.isValide(){
            let parameter = [RegisterRequestKey.email: self.emailTF.text as AnyObject,
                             RegisterRequestKey.password: self.passwordTF.text as AnyObject] as [String : AnyObject]
            if Reachable.isConnectedToNetwork(){
                SVProgressHUD.show()
                CryptoExchangeClient.sharedInstance().login(parameter, completionHandlerForLogin: { (result, error) in
                    guard let result = result else{
                        return
                    }
                    if let error = result["error"] as? NSDictionary {
                        SVProgressHUD.dismiss()
                        SwiftAlert().show(title: "Oppss!", message: String(describing: error["message"]!), viewController: self)
                    }
                    else{
                        let keychain = KeychainSwift()
                        keychain.set(result[UserResponseKey.id] as! String, forKey:UserResponseKey.id)
                        keychain.set(result[UserResponseKey.token] as! String, forKey: UserResponseKey.token)
                        print(result[UserResponseKey.id] ?? "no id")
                        print(result[UserResponseKey.token] ?? "no token")
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        UserDefaults.standard.synchronize()
                        CryptoExchangeClient.sharedInstance().getEthereumWallet([:], completionHandlerForEthereumWallet: { (response, error) in
                            SVProgressHUD.dismiss()
                            guard let response = response else{
                                return
                            }
                            if let _ = response["error"] as? NSDictionary {
                                if let next = self.storyboard?.instantiateViewController(withIdentifier: "CWMainVC") as? CWMainVC{
                                    UserDefaults.standard.set(false, forKey: "haveWallet")
                                    UserDefaults.standard.synchronize()
                                    let nv = UINavigationController(rootViewController: next)
                                    self.present(nv, animated: true, completion: nil)
                                    
                                }
                                return
                            }
                            if let next = self.storyboard?.instantiateViewController(withIdentifier: "CWMainVC") as? CWMainVC{
                                UserDefaults.standard.set(true, forKey: "haveWallet")
                                UserDefaults.standard.synchronize()
                                var res = response.value(forKey: "account") as! Dictionary<String, Any>
                                res["balance"] = response["balance"] as! String
                                next.data = res as NSDictionary
                                let nv = UINavigationController(rootViewController: next)
                                self.present(nv, animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
            else{
                SwiftAlert().show(title: "No Internet", message: "Please connect internet first", viewController: self)
            }
            
        }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CWLoginVC:UITextFieldDelegate {
    
    // MARK : - TEXTFILD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF:
            passwordTF.becomeFirstResponder()
            return false
        default:
            passwordTF.resignFirstResponder()
            return true
        }
    }
    
}
