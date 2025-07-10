//
//  OrderViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/08/24.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  This View Controller is for setting up the container and the top tag bar (menu bar) for order status view and order history view.
//  このView Controllerは、注文状態画面と注文履歴画面のcontainerとその切り替え用のタグをセットアップする。


import UIKit

class OrderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    // FIXME: it is not changing to upcoming order screen if the user clicking the order view first before ording an order.
    // It is because the isUpcomingOrder boolean is set when viewdidload and cannot be change afterward.
    // Trying to use segue. But found out that segue is not working when the 2 controller is nested in the same tab controller...
    @IBOutlet weak var pagingCollectionView: UICollectionView!
    
    var tagTitle = [String]()
    
    let pagingCellID = "pagingCellID"
    
    // this bool is for
    var isUpcomingOrder: Bool?
    
    var cell = UICollectionViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPagingCollectionView()
        setupMenuBar()
                
    }

    // TODO: Check the isUpcomingOrder boolean and switch the page in viewWillAppear to fix the bug above?????
//    override func viewWillAppear(_ animated: Bool) {
//
//
//    }
    
    private func setupPagingCollectionView() {
        
        pagingCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: pagingCellID)
        
        // push the view under the tag
        pagingCollectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        pagingCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    // fill up space with the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // standard process to create the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pagingCellID, for: indexPath)
        
        // refer to the VC of the view
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let upcomingOrderVC = mainStoryboard.instantiateViewController(withIdentifier: "OrderStatusViewController")
        let pastOrderVC = mainStoryboard.instantiateViewController(withIdentifier: "PastOrderViewController")
        let noUpcomingOrderVC = mainStoryboard.instantiateViewController(withIdentifier: "NoUpcomingOrderViewController")
        
        // set the view of the order view based on the order current status
        if indexPath.item == 0 && isUpcomingOrder != true {
            self.addChildViewController(noUpcomingOrderVC)
            cell.addSubview(noUpcomingOrderVC.view)
            noUpcomingOrderVC.willMove(toParentViewController: self)
        }
        
        if indexPath.item == 0 && isUpcomingOrder == true {
            self.addChildViewController(upcomingOrderVC)
            cell.addSubview(upcomingOrderVC.view)
            upcomingOrderVC.willMove(toParentViewController: self)
        }
        
        else if indexPath.item == 1 {
            self.addChildViewController(pastOrderVC)
            cell.addSubview(pastOrderVC.view)
            pastOrderVC.willMove(toParentViewController: self)
            
        }
        
        return cell
    }
    
    // eliminate the space between 2 pages
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // move the horizontal bar when the paging is moved
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    // make the tag button selected according to the current paging position
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    // scroll to the page when the menu bar item is selected.
    func scrollTo (menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        pagingCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // define the object of menu bar
    lazy var menuBar: OrderMenuBar = {
        let orderMenuBar = OrderMenuBar()
        orderMenuBar.orderViewController = self
        return orderMenuBar
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:|[v0(60)]|", views: menuBar)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
