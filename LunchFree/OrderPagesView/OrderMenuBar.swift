//
//  OrderMenuBar.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/09/04.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  The view and the controller for the top tag (menu bar) on the order view.
//  OrderViewControllerでの切り替えタグのView Controller

import UIKit

class OrderMenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let cellID = "tagCellID"
    let tagTitle = ["現在のオーダー", "過去のオーダー"]
    
    var ongoingOrderStatus: Bool?
    
    var orderViewController: OrderViewController?
    
    // configurate the tag colletion view here
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // init the collection view
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //register the cell first
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        
        // add the view of the collection view in specific position
        addSubview(collectionView)
        // add 0px space from the left edge. [v0] refer to the element that you want to add
        addContraintsWithFormat("H:|[v0]|", views: collectionView)
        // add 10px space from the top edge
        addContraintsWithFormat("V:|-10-[v0]|", views: collectionView)
        
        // preselect the tag when the page init
        let selectIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectIndexPath, animated: false, scrollPosition: [])
        collectionView.isScrollEnabled = false
        
        setupHorizontalBar()
        
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    // make a dedicated bar under the tag
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.black
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(horizontalBarView)
            
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // standard process to create the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        cell.tagLabel.text = tagTitle[indexPath.item]
        cell.tagLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        cell.tagLabel.textColor = cell.isSelected ? UIColor.black : UIColor.darkGray
        
        return cell
        
    }
    
    // make the width of the cell as half of it's width and the same as its height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    // eliminate the gap between 2 tag
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // scroll the view to the designated position when the tag is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        orderViewController?.scrollTo(menuIndex: indexPath.item)
    }
    
}

class MenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // configurate the collection cell when it is selected
    override var isSelected: Bool {
        didSet {
            tagLabel.textColor = isSelected ? UIColor.black: UIColor.darkGray
        }
    }
    
    let tagLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        return tl
    }()
    
    // configurate the view for the tag cell
    func setupViews() {
        
        backgroundColor = UIColor.white
        
        addSubview(tagLabel)
        addContraintsWithFormat("H:[v0(\(375/2))]", views: tagLabel)
        addContraintsWithFormat("V:[v0(50)]", views: tagLabel)
        
        // postion the cell in the center of the collection view
        addConstraint(NSLayoutConstraint(item: tagLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: tagLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

    
}


