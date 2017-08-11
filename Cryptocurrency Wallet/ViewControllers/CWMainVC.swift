//
//  CWMainVC.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit_BuiltByBlank on 8/11/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import UIKit

class CWMainVC: UIViewController {
    
    var data:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let response = data else {
            return
        }
        print(response["account"])
        print((response["account"] as! Dictionary)["createdAt"]!)
        print(self.getLocalTimeStringFrom(String(describing: (response["account"] as! NSDictionary)["createdAt"]!)))
        
        print(response)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
