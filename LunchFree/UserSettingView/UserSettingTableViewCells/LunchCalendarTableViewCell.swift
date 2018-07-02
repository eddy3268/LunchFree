//
//  LunchCalendarTableViewCell.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/09/02.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  Table view cell for the calendar item which allow user to choose what day they want or don't want their lunch
//  特定した日にちにランチセットを配達するか否かを事前に設定できる項目。

//  Maybe I don't need it? Just change it the template cell and make it open a new view controller for calendar.
import UIKit

class LunchCalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var calendarTitle: UILabel!

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
