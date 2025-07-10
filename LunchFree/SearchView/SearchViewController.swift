//
//  SecondViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/08/03.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  This is the screen for users to search their favorite lunch set that available on the day.
//  もし日替わりのおすすめの中で、お気入りのランチセットがなければ、ユーザーがこのサーチ画面で好きなランチセットを検索できます。

import UIKit
// TODO: put the cell data to cloud firestore

struct restaurantlunchData {
    let lunchSetName: String!
    let restaurantName: String!
    let image: UIImage!
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var searchResultView: UITableView!
    
    // set a container view for the search bar to fix the search bar on the top of the screen.
    @IBOutlet weak var searchBarContainerView: UIView!
    
    var dataList = [restaurantlunchData]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults = [restaurantlunchData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // all restaurant data
        dataList = [restaurantlunchData(lunchSetName: "京野菜定食", restaurantName: "〇〇野菜キッチン", image: #imageLiteral(resourceName: "lunchSetSample")),
                    restaurantlunchData(lunchSetName: "タコス定食", restaurantName: "アメリカンソウルフード", image: #imageLiteral(resourceName: "lunchSetSample2")),
                    restaurantlunchData(lunchSetName: "三元豚とんかつ定食", restaurantName: "〇〇屋", image: #imageLiteral(resourceName: "lunchASetSample3")),]
        
        // set up search bar and configure the search controller
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.becomeFirstResponder()
        
        // Configure the apperence of the search bar
        searchController.searchBar.placeholder = "セット名を入力してください"
        searchController.searchBar.searchBarStyle = .minimal
        // add the search bar to container view and set it to fit the container view
        searchBarContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.frame.size.width = self.view.frame.size.width
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 300

    }
    
    // FIXME: so how to search both lunchSetName and restaurantName?
    func updateSearchResults(for searchController: UISearchController) {
        searchResults = dataList.filter({ data in
            return data.lunchSetName.contains(searchController.searchBar.text!)
        })
        
        searchResultView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: save the order information and send it to the sever
        let placeOrderActionSheet = UIAlertController(title: nil, message: "注文しますか？", preferredStyle: .actionSheet)
        
        placeOrderActionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (UIAlertAction) in
            print("Cancel button pressed")
        }))
        placeOrderActionSheet.addAction(UIAlertAction(title: "注文する", style: .default, handler: { (UIAlertAction) in
            // TODO: capture the order and user information (i.e. which lunch set did the user select, user name, location, order time, deliverary time...) send the order and user information to the sever
            print("Order button pressed")
            
            // show the order status page on the order tag
            // FIXME: if the user tap the order view before placing an order, it cannot change it back to the view to display the order status.
            let navVC = self.tabBarController?.viewControllers?[2] as! UINavigationController
            let orderVC = navVC.topViewController as! OrderViewController
            orderVC.isUpcomingOrder = true
            
            self.tabBarController?.selectedIndex = 2
            
            
        }))
        
        present(placeOrderActionSheet, animated: true, completion: nil)
        
        // deselect the cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell

        let currentData: restaurantlunchData
        if searchController.isActive && searchController.searchBar.text != "" {
            currentData = searchResults[indexPath.row]
        } else {
            currentData = dataList[indexPath.row]
        }

        cell.lunchSetImageView.image = currentData.image
        cell.restaurantNameLabel.text = currentData.restaurantName
        cell.lunchSetNameLabel.text = currentData.lunchSetName

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return searchResults.count
        } else {
            return dataList.count
        }
    }
    
}
