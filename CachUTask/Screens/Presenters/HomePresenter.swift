//
//  HomePresenter.swift
//  CachUTask
//
//  Created by zeyad on 10/22/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

protocol HomeDelegate{
    func showProgressView()
    func hideProgressView()
    func requestSucceed(products:[Product])
    func requestDidFailed(message: String)
}


import Foundation

class HomePresenter {
    
    var delegate: HomeDelegate
    
    init(delegate: HomeDelegate) {
        self.delegate = delegate
    }
    
    func getProducts(page: Int){
            self.delegate.showProgressView()
            NetworkManager.shared.getProductList(page: page) { [weak self] (result) in
                guard let self = self else {return}
                self.delegate.hideProgressView()
                switch result {
                case .success(let productList):
                    guard let products = productList.data?.products else {return}
                    self.delegate.requestSucceed(products: products)
                    let realmProducts = PresistenceManager.shared.buildRealmModel(from: products)
                    PresistenceManager.shared.saveProducts(products: realmProducts) {
                        print("Cached")
                    }
                case .failure(let error):
                    self.delegate.requestDidFailed(message: error.localizedDescription)
                }
            }
        }
}
