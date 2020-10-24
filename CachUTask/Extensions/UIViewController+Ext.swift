//
//  UIViewController+Ext.swift
//  GitFollowers
//
//  Created by zeyad on 6/23/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertOnMainThread(title:String , messaeg:String , buttonTitle:String){
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: messaeg, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            ac.addAction(action)
            ac.modalPresentationStyle = .overFullScreen
            ac.modalTransitionStyle = .crossDissolve
            self.present(ac, animated: true)
        }
    }
}
