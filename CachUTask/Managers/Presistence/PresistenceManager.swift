//
//  PresistenceManager.swift
//  GitFollowers
//
//  Created by zeyad on 6/27/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit
import RealmSwift

class PresistenceManager {
    
    static let shared = PresistenceManager()
    
    func saveProducts(products:[RProductModel] , success: @escaping () -> Void ){
        
        let productRealmList = List<RProductModel>()
        
        for product in products {
            productRealmList.append(product)
        }
        
        DispatchQueue.main.async{
            let realm = try! Realm()
            try! realm.write {
                debugPrint("Realm add \(Thread.current)")
                realm.add(productRealmList)
                success()
            }
        }
        
    }
    
    func fetchProducts(success: @escaping ((_ products: [RProductModel]?) -> Void) ){
        
        let realm = try! Realm()
        let rProducts = realm.objects(RProductModel.self)
        var products = [RProductModel]()
        
        for product in rProducts {
            products.append(product)
        }
        success(products)
    }
    
    func deleteAllObjects(){
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    //This fuction construct a realm data base object from the api object model for easy maintenance and future changes in model changes 
    func buildRealmModel(from products : [Product]) -> [RProductModel] {
        var rProducts = [RProductModel]()
        for product in products {
            let rproduct = RProductModel(product: product)
            rProducts.append(rproduct)
        }
        return rProducts
    }
    
}


