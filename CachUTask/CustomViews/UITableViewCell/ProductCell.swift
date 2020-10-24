//
//  FavoriteCell.swift
//  GitFollowers
//
//  Created by zeyad on 6/28/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    static let reuseID = "ProductCell"
    let productImageView = CUProductImageView(frame: .zero )
    let productNameLabel = CUTitleLabel(textAlignment: .left, fontSize: 25)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.productImageView.image = Images.placeholder
        self.productNameLabel.text = ""
    }
    
    func set(with product:RProductModel){
        productImageView.downloadImage(fromURL: product.imageURl ?? "" )
        productNameLabel.text = product.name ?? "This prduct has no name"
    }
    
    func set(with product:Product){
        productImageView.downloadImage(fromURL: product.links?.first?.link ?? "" )
        productNameLabel.text = product.nameEn ?? "This prduct has no name"
       }
    
    private func configure(){
        addSubViews(productImageView,productNameLabel)
        productNameLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let padding:CGFloat = 12
        NSLayoutConstraint.activate([
            productImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            productImageView.heightAnchor.constraint(equalToConstant: 60),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            
            productNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 24),
            productNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            productNameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
