//
//  GFEmptyStateView.swift
//  GitFollowers
//
//  Created by zeyad on 6/25/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {

    let emptyStateImage = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configure(){
        addSubViews(emptyStateImage)
        
        emptyStateImage.image = Images.emptyState
        emptyStateImage.translatesAutoresizingMaskIntoConstraints = false
                 
        NSLayoutConstraint.activate([
            emptyStateImage.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1.3),
            emptyStateImage.heightAnchor.constraint(equalTo: emptyStateImage.widthAnchor),
            emptyStateImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateImage.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
    }
}
