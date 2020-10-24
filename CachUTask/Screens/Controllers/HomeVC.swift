//
//  ViewController.swift
//  CachUTask
//
//  Created by zeyad on 10/20/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import UIKit

class HomeVC: DataLoadingVC {
    
    //MARK:- UIElements
    let productsLabel = CUTitleLabel(textAlignment: .center, fontSize: 30)
    let tableView = UITableView(frame: .zero)
    let clearButton = UIButton(frame: .zero)
    let reloadButton = UIButton(frame: .zero)
    
    var presenter: HomePresenter?

    //This flag is instead of connectivity pod it will set to true when api request fails and to set datasourc to the array we got from realm database.
    var isOffline:Bool = false{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.layoutSubviews()
            }
        }
    }
    
    //MARK:- Datasource
    
    //array of cached objects
    var realmProducts = [RProductModel](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.layoutSubviews()
            }
        }
    }
    // the array comes from api call 
    var apiProducts = [Product]()
    
    
    //MARK:- Pagination
    var page = 0
    var isLoading = false
    var hasMore = true
    
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        configureTableView()
        fetchData()
    }

    
    //MARK:- Autolayout
    func layoutUI(){
        self.view.addSubViews(productsLabel , tableView , clearButton , reloadButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            productsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productsLabel.heightAnchor.constraint(equalToConstant: 42),
            
            tableView.topAnchor.constraint(equalTo: productsLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) ,
            
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            clearButton.centerYAnchor.constraint(equalTo: productsLabel.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 30),
            clearButton.heightAnchor.constraint(equalToConstant: 30),
            
            reloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            reloadButton.centerYAnchor.constraint(equalTo: productsLabel.centerYAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: 30),
            reloadButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    //MARK:- Configure UI
    func configureUI(){
        self.presenter = HomePresenter(delegate: self)
        tableView.backgroundColor = .lightGray
        productsLabel.text = "PRODUCTS"
        productsLabel.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        view.backgroundColor = .white
        clearButton.tintColor = .darkGray
        clearButton.addTarget(self, action: #selector(clearAllData), for: .touchUpInside)
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
        reloadButton.setImage(UIImage(named: "reload"), for: .normal)
    }
    
    func configureTableView(){
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.backgroundColor = .white
        tableView.accessibilityIdentifier = "ProductTableView"
    }
    
    
    //MARK:- Buttons targets
    
    //This funciton delete all data sources and cache
    @objc func clearAllData(){
        self.apiProducts.removeAll()
        self.realmProducts.removeAll()
        PresistenceManager.shared.deleteAllObjects()
        self.tableView.reloadData()
        self.showEmptyStateView()
    }
    
    @objc func reloadData(_ sender: UIButton){
        self.dismissEmptyStateView()
        self.fetchData()
    }
    
    
    //MARK:- Network + Realm
    
    //This func first get to realm database if there is a data it will feed data sources with realm data , if not it will reload data from api
    func fetchData() {
        PresistenceManager.shared.fetchProducts { (products) in
            if let products = products   ?? nil , products.count != 0 {
                self.realmProducts = products
                self.isOffline = true 
            }else {
                self.presenter?.getProducts(page: self.page)
            }
        }
    }
    
    func appendNewProducts(products:[Product]){
        for product in products {
            self.appendNewItem(product)
        }
    }
    
    //This func to insert updates to tableview with out need to reload the whole tableView data
    func appendNewItem(_ product: Product) {
        DispatchQueue.main.async {
            self.apiProducts.append(product)
            let selectedIndexPath = IndexPath(row: self.apiProducts.count - 1, section: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [selectedIndexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }

}

//MARK:- TableView Delegate

extension HomeVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isOffline {
            return apiProducts.count
        }else {
            return realmProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseID, for: indexPath) as! ProductCell
        if !isOffline {
            cell.set(with: self.apiProducts[indexPath.row])

        }else {
            cell.set(with: self.realmProducts[indexPath.row])
        }
       return cell

    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !isOffline {
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.height
            let offsetY = scrollView.contentOffset.y
            if offsetY > contentHeight - height {
                guard hasMore , !isLoading else {return}
                page += 1
              self.presenter?.getProducts(page: self.page)
            }
        }
      }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
           UIView.animate(withDuration: 0.4) {
               cell.transform = CGAffineTransform.identity
           }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell is selected and tapped at \(indexPath.row)")
        let ac = UIAlertController(title: "Cell", message: "You clicked cell at index of  \(indexPath.row )", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        ac.addAction(okAction)
        self.present(ac,animated: true)
    }
}

//MARK:- Home Delegate

extension HomeVC: HomeDelegate {
    func showProgressView() {
        self.showLoadingView()
        isLoading = true
    }
    
    func hideProgressView() {
        self.dismissLoadingView()
        isLoading = false
    }
    
    func requestSucceed(products: [Product]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.appendNewProducts(products: products)
            self.isOffline = false
        }
    }
    
    func requestDidFailed(message: String) {
           self.presentAlertOnMainThread(title: "Server error", messaeg: message, buttonTitle: "OK")
        self.isOffline = true
    }
}
