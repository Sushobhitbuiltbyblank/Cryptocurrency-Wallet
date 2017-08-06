
//
//  UIViewControllerExtension.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit Jain on 05/08/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func addTapToHideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnViewTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardOnViewTap() {
        
        self.view.endEditing(true)
    }
}
