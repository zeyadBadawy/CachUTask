//
//  UIView+Ext.swift
//  GitFollowers
//
//  Created by zeyad on 6/29/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinToTheEdges(of superView:UIView){
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
        ])
    }

    func addSubViews(_ views:UIView...){
        for view in views {
            addSubview(view)
        }
    }
}
