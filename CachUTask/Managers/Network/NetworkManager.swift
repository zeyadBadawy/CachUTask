//
//  NetworkManager.swift
//  GitFollowers
//
//  Created by zeyad on 6/23/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://run.mocky.io/v3/27867999-8b3e-4c04-a761-42def62ea1e8"
    let cache = NSCache<NSString,UIImage>()
    
    
    func getProductList(page:Int , completion: @escaping (Result<ProductListModel,CUError>) -> Void ) {
        let endPonit = baseURL
        guard let url = URL(string: endPonit) else {
            completion(.failure(.invalidURL))
            return
        }
                
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.connectionError))
                return
            }
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidDate))
                return
            }
            do {
                let decoder = JSONDecoder()
                let productListModel = try decoder.decode(ProductListModel.self, from: data)
                completion(.success(productListModel))
            }
            catch{
                completion(.failure(.decodeError))
            }
        }
        
        task.resume()
    }
    
    //MARK:- Download images(only one time) then Caching it 
    func downloadImage(from stringURL:String , completed: @escaping (UIImage?) -> Void) {
        let imageKey = NSString(string: stringURL)

        if let image = cache.object(forKey: imageKey) {
            completed(image)
            return
        }

        guard let url = URL(string: stringURL) else {
            completed(nil)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self ,
                error == nil ,
                let response = response as? HTTPURLResponse ,
                response.statusCode == 200 ,
                let data = data ,
                let image = UIImage(data: data)
                else {

                    completed(nil)
                    return
            }
            self.cache.setObject(image, forKey: imageKey)
            completed(image)
        }

        dataTask.resume()
    }

}
