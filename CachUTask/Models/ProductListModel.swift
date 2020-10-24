//
//  ProductListModel.swift
//  CachUTask
//
//  Created by zeyad on 10/20/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import Foundation

// MARK: - ProjectSearchResult
class ProductListModel: Codable {
    
    var  data: ListData?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

// MARK: - ListData
class ListData:Codable {
    
    var products:[Product]?
    
    enum CodingKeys: String, CodingKey {
        case products = "products"
    }
}

// MARK: - Product
class Product:Codable {
    
    var nameEn: String?
    var links: [Link]?
    
    enum CodingKeys: String, CodingKey {
        case nameEn = "name_en"
        case links = "Links"
    }
    
}

// MARK: - Link
class Link:Codable {
    
    var link: String?
    
    enum CodingKeys: String, CodingKey {
        case link = "link"
    }
    
}


