//
//  CWRegisterVC.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit Jain on 05/08/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import UIKit
import SVProgressHUD
import KeychainSwift

class CWRegisterVC: UIViewController {

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var registerBtn: UIButton!
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
    
    @IBAction func registerAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.isValide(){
            let parameter = [RegisterRequestKey.name:self.nameTF.text as AnyObject,
                             RegisterRequestKey.email: self.emailTF.text as AnyObject,
                             RegisterRequestKey.phone: self.phoneTF.text as AnyObject,
                             RegisterRequestKey.password: self.passwordTF.text as AnyObject] as [String : AnyObject]
            if Reachable.isConnectedToNetwork(){
                SVProgressHUD.show()
                CryptoExchangeClient.sharedInstance().register(parameter, completionHandlerForResigter: { (result, error) in
                    SVProgressHUD.dismiss()
                    guard let result = result else{
                        return
                    }
                    if let statusCode = result["statusCode"] as? Int {
                        print("Your request returned a status code other than 2xx!")
                        SwiftAlert().show(title:"Show statusCode \(statusCode)", message: result["message"] as! String, viewController: self)
                        return
                    }
                    else{
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        UserDefaults.standard.synchronize()
                        let keychain = KeychainSwift()
                        keychain.set(result[UserResponseKey.id] as! String, forKey:UserResponseKey.id)
                        keychain.set(result[UserResponseKey.token] as! String, forKey: UserResponseKey.token)
                        print(result[UserResponseKey.id] ?? "no id")
                        print(result[UserResponseKey.token] ?? "no token")
                        SVProgressHUD.dismiss()
                        if let next = self.storyboard?.instantiateViewController(withIdentifier: "CWMainVC") as? CWMainVC{
                            let nv = UINavigationController(rootViewController: next)
                            self.present(nv, animated: true, completion: nil)
                            UserDefaults.standard.set(true, forKey: "haveWallet")
                            UserDefaults.standard.synchronize()
                        }
                    }
                })
            }
            else{
                SwiftAlert().show(title: "No Internet", message: "Please connect internet first", viewController: self)
            }
        }
    }
    
    func assignTFDelegate()
    {
        self.nameTF.delegate = self
        self.passwordTF.delegate = self
        self.emailTF.delegate = self
        self.phoneTF.delegate = self
    }

    func isValide()->Bool
    {
        if (self.nameTF.text?.isEmpty)!
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in your Name", viewController: self)
            return false
        }
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
        if (self.phoneTF.text?.isEmpty)!
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in your phoneNumber", viewController: self)
            return false
        }
       
        if !Validator.sharedInstance.isValidEmail(testStr: self.emailTF.text!)
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in valid email address", viewController: self)
            return false
        }
        if !Validator.sharedInstance.isStringOfLength(str: self.passwordTF.text!, len: 8)
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in password minimum of 8", viewController: self)
            return false
        }
        if !Validator.sharedInstance.isStringOfLength(str: self.phoneTF.text!, len: 10)
        {
            SwiftAlert().show(title: "Almost there", message: "Please Fill in phone number of minimum 10 digit", viewController: self)
            return false
        }
        return true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension CWRegisterVC:UITextFieldDelegate {
    
    // MARK : - TEXTFILD DELEGATE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTF:
            passwordTF.becomeFirstResponder()
            return false
        case passwordTF:
            emailTF.becomeFirstResponder()
            return false
        case emailTF:
            phoneTF.becomeFirstResponder()
            return false
        default:
            phoneTF.resignFirstResponder()
            return true
        }
    }
    
}
