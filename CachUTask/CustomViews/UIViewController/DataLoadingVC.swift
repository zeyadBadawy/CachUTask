//
//  DataLoadingVC.swift
//  StarsConstruction
//
//  Created by zeyad on 8/9/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

class DataLoadingVC: UIViewController {
    
    var loadView:UIView!
    var emptyStateView:GFEmptyStateView!
    
    func showLoadingView(){
        DispatchQueue.main.async {
            self.loadView = UIView(frame: UIScreen.main.bounds)
            self.view.addSubview(self.loadView)
            
            self.loadView.backgroundColor = .clear
            self.loadView.alpha = 0
            
            UIView.animate(withDuration: 0.15) {
                self.loadView.alpha = 0.8
            }
            
            let activivtyIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activivtyIndicator.color = #colorLiteral(red: 0.1411764706, green: 0.1647058824, blue: 0.2156862745, alpha: 1)
            self.loadView.addSubview(activivtyIndicator)
            
            activivtyIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                activivtyIndicator.centerYAnchor.constraint(equalTo: self.loadView.centerYAnchor),
                activivtyIndicator.centerXAnchor.constraint(equalTo: self.loadView.centerXAnchor)
            ])
            activivtyIndicator.startAnimating()
        }
    }
    
    
    func dismissLoadingView(){
        DispatchQueue.main.async {
            if self.loadView != nil {
                self.loadView.removeFromSuperview()
                self.loadView = nil
            }
        }
    }
    
    func showEmptyStateView(){
        if emptyStateView == nil {
            emptyStateView = GFEmptyStateView(frame: CGRect(x: 0, y: 150, width: UIScreen.main.bounds.width   , height: 600))
            emptyStateView.backgroundColor = .white
            view.addSubview(emptyStateView)
        }
    }
    
    func dismissEmptyStateView(){
        if self.emptyStateView != nil {
            self.emptyStateView.removeFromSuperview()
            self.emptyStateView = nil
        }
    }
}
