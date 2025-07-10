//
//  Extension.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/09/04.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//

import UIKit

extension UIView {
    
    // enable the symbol format language of constraint.
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    // extension for setting image & button rounded
    func setRounded (cornerRadius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    func cardView () {
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 8
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: -5, height: 10)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        self.clipsToBounds = false
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
