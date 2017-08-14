//
//  CWMainVC.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit_BuiltByBlank on 8/11/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import UIKit
import SVProgressHUD
import KeychainSwift

class CWMainVC: UIViewController {
    
    var data:NSDictionary?
    @IBOutlet weak var balanceL: UILabel!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var createWalletV: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let haveWallet = UserDefaults.standard.value(forKey: "haveWallet") as! Bool
        if haveWallet == true {
            if Reachable.isConnectedToNetwork(){
                SVProgressHUD.show()
                CryptoExchangeClient.sharedInstance().getEthereumWallet([:], completionHandlerForEthereumWallet: { (response, error) in
                    SVProgressHUD.dismiss()
                    guard let response = response else{
                        return
                    }
                    print(response)
                    var res = response.value(forKey: "account") as! Dictionary<String, Any>
                    res["balance"] = response["balance"] as! String
                    self.data = res as NSDictionary
                })
                CryptoExchangeClient.sharedInstance().getEthereumTransactionHistory([:], completionHandlerForEthereumWallet: { (response, error) in
                    print(response)
                })
            }
        }
        self.setUpView()
    }
    func setUpView()
    {
        let haveWallet = UserDefaults.standard.value(forKey: "haveWallet") as! Bool
        if haveWallet == true {
            self.createWalletV.isHidden = true
            guard let response = data else {
                return
            }
            print(response["createdAt"]!)
            print(self.getLocalTimeStringFrom(response["createdAt"]! as! String))
            print(response)
            guard let balance = response["balance"] as? String else {
                return
            }
            self.balanceL.text = balance
        }
        else{
            
        }
    }
    
    @IBAction func createWalletAction(_ sender: Any) {
        CryptoExchangeClient.sharedInstance().creatWallet([:], completionHandlerForCreateWallet: { (response, error) in
            guard let response = response else{
                return
            }
            self.data = response
            self.createWalletV.isHidden = true
            self.setUpView()
        })
        
    }
    func getLocalTimeStringFrom(_ serverTime:String)->String
    {
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        df.timeZone = TimeZone(abbreviation: "UTC")
        let date = df.date(from: serverTime)!
        print(df.string(from: date))
        
        let localTimeZone = TimeZone.current
        df.timeZone = localTimeZone
        let localDate = df.date(from: serverTime)!
        print(localDate)
        return df.string(from: localDate)
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

extension CWMainVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Data Source method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - Delegate method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
