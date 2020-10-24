//
//  GFAvatarImageView.swift
//  GitFollowers
//
//  Created by zeyad on 6/23/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

class CUProductImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeHolderImage = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        contentMode = .scaleAspectFit 
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromURL url:String){
        if url.count == 0 {
            return
        }
        NetworkManager.shared.downloadImage(from: url) {[weak self] (image) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

