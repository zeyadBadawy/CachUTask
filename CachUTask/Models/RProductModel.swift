//
//  RProductModel.swift
//  CachUTask
//
//  Created by zeyad on 10/22/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import Foundation
import RealmSwift

class RProductModel:Object {
    
    @objc dynamic var name:String?
    @objc dynamic var imageURl:String?
    
    convenience init(product:Product) {
        self.init()
        self.name = product.nameEn
        self.imageURl = product.links?.first?.link
    }
    
}
