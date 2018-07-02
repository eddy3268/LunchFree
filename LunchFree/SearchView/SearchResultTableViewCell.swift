//
//  SearchResultTableViewCell.swift
//  LunchFree
//
//  Created by Eddy Chan on 2018/06/29.
//  Copyright © 2018 Eddy Chan. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lunchSetImageView: UIImageView!
    @IBOutlet weak var lunchSetNameLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
