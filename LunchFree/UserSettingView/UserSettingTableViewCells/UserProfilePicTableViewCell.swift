//
//  UserProfilePicTableViewCell.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/08/04.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  The profile picture cell for the user setting view
//  ユーザーのプロフィール写真項目のtableView cell



import UIKit

protocol UserProfilePicTableViewCellDelegate {
    func editProfilePic() -> Void
}

class UserProfilePicTableViewCell: UITableViewCell {
    
    var delegate: UserProfilePicTableViewCellDelegate?
    
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editProfilePicButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicView.setRounded(cornerRadius: profilePicView.frame.height / 2)
        editProfilePicButton.setRounded(cornerRadius: editProfilePicButton.frame.height/2)
    }
    
    
    @IBAction func editProfilePic(_ sender: UIButton) {
        
        if let delegate = self.delegate {
            delegate.editProfilePic()
        }
 
    }
    
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
