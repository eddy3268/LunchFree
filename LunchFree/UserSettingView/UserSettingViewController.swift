//
//  UserSettingViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/08/03.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  User Setting View
//  ユーザー設定画面
//

import UIKit
import Firebase

struct cellData {
    let cellID: String!
    var title: String!
    var image: UIImage?
}

class UserSettingViewController: UITableViewController, UserProfilePicTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var datePickerIndexPath: IndexPath?
    
    var lunchCalendar: IndexPath?
    
    var dateFormatter = DateFormatter()
    
    var userProfileCellData = [cellData]()
    
    //[START configure Firebase Auth]
    var auth: Auth?
    //[END cnfigure Firebase Auth]
    
    //[START def firebase database]
    var docRef: DocumentReference!
    var userDataListener: ListenerRegistration!
    //[END def firebase database]
    
    //[START def user data]
    var userName: String!
    var selectedPlanName: String!
    // Have to set the property like this because it is in conflict with the setter of datepicker
    var lunchTimeData: String!
    //[END def user data]

    // Row Height
    var profilePicSetionRowHeight: CGFloat = 250
    var datePickerCellRowHeight: CGFloat = 216
    var profileSettingItemRowHeight: CGFloat = 60
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // item data
        userProfileCellData = [cellData(cellID: "profilePicSection", title: nil, image: #imageLiteral(resourceName: "profilePicSample")),
                               cellData(cellID: "profileSettingItem", title: "基本情報", image: #imageLiteral(resourceName: "basicInfoIcon")),
                               cellData(cellID: "settingItemWithDetail", title: "ランチプラン", image: #imageLiteral(resourceName: "jpyIcon")),
                               cellData(cellID: "profileSettingItem", title: "好きな食べ物",  image: #imageLiteral(resourceName: "favoriteFoodIcon")),
                               cellData(cellID: "profileSettingItem", title: "アレルギー", image: #imageLiteral(resourceName: "allergyFoodIcon")),
                               cellData(cellID: "settingItemWithDetail", title: "ランチタイム", image: #imageLiteral(resourceName: "lunchTimeIcon"))]
//                               cellData(cellID: "lunchCalendarItem", title: "ランチカレンダー", detail: nil, image: #imageLiteral(resourceName: "calendarIcon"))]
        
        // [START get the uid]
        auth = Auth.auth()
        let currentUser = auth?.currentUser
        let uid = currentUser!.uid
        // [END get the uid]
        
        //[START fetching user data]
        docRef = Firestore.firestore().collection("users").document("\(uid)")
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let userData = docSnapshot.data()
            self.userName = userData!["userName"] as? String ?? ""
            self.selectedPlanName = userData!["selectedPlanName"] as? String ?? ""
            self.lunchTimeData = userData!["lunchTime"] as? String ?? ""
            // TODO: fetch other data and set it as the initial status when it's loaded
        }
        
        //[END fetching user data]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If the user changed the data
        //[START updating user data]
        userDataListener = docRef.addSnapshotListener { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let userData = docSnapshot.data()
            self.userName = userData!["userName"] as? String ?? ""
            self.selectedPlanName = userData!["selectedPlanName"] as? String ?? ""
            self.lunchTimeData = userData!["lunchTime"] as? String ?? ""
            self.tableView.reloadData()
        }
        //[END updating user data]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if datePickerIndexPath != nil {
            return userProfileCellData.count + 1
        }
        
        return userProfileCellData.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// let the datePicker cell
        if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell")!
            let datePicker = cell.viewWithTag(1) as! UIDatePicker
            dateFormatter.dateFormat = "HH:mm"
            datePicker.datePickerMode = .time
            // TODO: see if it is possible to eliminate other time options in the picker
            datePicker.minimumDate = dateFormatter.date(from: "11:00")
            datePicker.maximumDate = dateFormatter.date(from: "15:00")
            
            let parentData = userProfileCellData[indexPath.row - 1]
            // load the user preference here. Will change it to loading from data base
            if parentData.title == "ランチタイム" && lunchTimeData != "" {
                datePicker.setDate(dateFormatter.date(from: lunchTimeData)!, animated: true)
            } else {
                datePicker.setDate(dateFormatter.date(from: "11:00")!, animated: false)
            }
            
            return cell
            
            
        // When the datePicker is expanding and the row that creating is under the expanded datepicker
        } else if datePickerIndexPath != nil && datePickerIndexPath!.row + 1 == indexPath.row  {
            switch userProfileCellData[indexPath.row - 1].cellID {
            case "lunchCalendarItem":
                let cell = tableView.dequeueReusableCell(withIdentifier: "lunchCalendarCell", for: indexPath) as! LunchCalendarTableViewCell
                
                cell.calendarIcon.image = userProfileCellData[indexPath.row - 1].image
                cell.calendarTitle.text = userProfileCellData[indexPath.row - 1].title
                
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "lunchCalendarCell", for: indexPath) as! LunchCalendarTableViewCell
                
                cell.calendarIcon.image = userProfileCellData[indexPath.row].image
                cell.calendarTitle.text = userProfileCellData[indexPath.row].title
                
                return cell
            }
        }
        
        
        else {
            
            // For the configuration of setting item
            switch userProfileCellData[indexPath.row].cellID {
            case "profilePicSection":
                let cell = Bundle.main.loadNibNamed("UserProfilePicTableViewCell", owner: self, options: nil)?.first as! UserProfilePicTableViewCell
                
                cell.delegate = self
                cell.userNameLabel.text = userName
                cell.profilePicView.image = userProfileCellData[indexPath.row].image
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                return cell
                
            case "profileSettingItem":
                let cell = Bundle.main.loadNibNamed("UserProfileItemTableViewCell", owner: self, options: nil)?.first as! UserProfileItemTableViewCell
                
                cell.itemIcon.image = userProfileCellData[indexPath.row].image
                cell.itemTitle.text = userProfileCellData[indexPath.row].title
                
                return cell
                
            case "settingItemWithDetail":
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingWithDetailCell", for: indexPath) as! profileSettingWithDetailCell
                
                cell.icon.image = userProfileCellData[indexPath.row].image
                cell.title.text = userProfileCellData[indexPath.row].title
                
                // display the time from the saved data.
                if userProfileCellData[indexPath.row].title == "ランチプラン" {
                    if selectedPlanName != nil && selectedPlanName != "" {
                        cell.detail.text = selectedPlanName
                    } else {
                        cell.detail.text = "未設定"
                    }
                }
                
                if userProfileCellData[indexPath.row].title == "ランチタイム" {
                    if lunchTimeData != "" {
                        cell.detail.text = lunchTimeData
                    } else {
                        cell.detail.text = "未設定"
                    }
                }
                
                return cell
                
            case "lunchCalendarItem":
                let cell = tableView.dequeueReusableCell(withIdentifier: "lunchCalendarCell", for: indexPath) as! LunchCalendarTableViewCell
                
                cell.calendarIcon.image = userProfileCellData[indexPath.row].image
                cell.calendarTitle.text = userProfileCellData[indexPath.row].title
                
                return cell
                
            default:
                let cell = Bundle.main.loadNibNamed("UserProfileItemTableViewCell", owner: self, options: nil)?.first as! UserProfileItemTableViewCell
                
                cell.itemIcon.image = userProfileCellData[indexPath.row].image
                cell.itemTitle.text = userProfileCellData[indexPath.row].title
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if datePickerIndexPath != nil && datePickerIndexPath!.row == indexPath.row {
            
            return datePickerCellRowHeight
            
        } else if datePickerIndexPath != nil && datePickerIndexPath!.row + 1 == indexPath.row {
            
            switch userProfileCellData[indexPath.row - 1].cellID {
            case "lunchCalendarItem":
                return profileSettingItemRowHeight
            default:
                return profileSettingItemRowHeight
            }
            
        } else {
            
            switch userProfileCellData[indexPath.row].cellID {
            case "profilePicSection":
                return profilePicSetionRowHeight
                
            case "profileSettingItem":
                return profileSettingItemRowHeight
                
            case "settingItemWithDetail":
                return profileSettingItemRowHeight
                
            case "lunchCalendarItem":
                return profileSettingItemRowHeight
                
            default:
                return 0
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // When the datepicker is expanding and the selected row is under the datepicker
        if datePickerIndexPath != nil && datePickerIndexPath!.row + 1 == indexPath.row  {
            
            var parentIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
            
            // add the same code when configating the row under the datepicker
            switch userProfileCellData[parentIndexPath.row].cellID {
            case "lunchCalendarItem":
                collapseDatePicker()
                tableView.deselectRow(at: parentIndexPath, animated: true)
            default:
                collapseDatePicker()
                tableView.deselectRow(at: parentIndexPath, animated: true)
            }
            
        }
        
        else {
            switch userProfileCellData[indexPath.row].cellID {
            
            case "profileSettingItem":
                // set the behavior of the setting item cell based on the title
                // TODO: set all the items launch destinated segue
                if userProfileCellData[indexPath.row].title == "基本情報" {
                    performSegue(withIdentifier: "showPersonalInfo", sender: self)
                }
                
                if userProfileCellData[indexPath.row].title == "好きな食べ物" {
                    performSegue(withIdentifier: "showFavFood", sender: self)
                }
                
                if userProfileCellData[indexPath.row].title == "アレルギー" {
                    performSegue(withIdentifier: "showAllergyFood", sender: self)
                }
                
                collapseDatePicker()
                
            case "settingItemWithDetail":
                // set the behavior of the cell based on the title
                if userProfileCellData[indexPath.row].title == "ランチタイム" && datePickerIndexPath != nil {
                    // collapse the date picker if it is already expanded
                    collapseDatePicker()
                } else if userProfileCellData[indexPath.row].title == "ランチタイム" && datePickerIndexPath == nil {
                    // show the datepicker
                    tableView.beginUpdates()
                    datePickerIndexPath = calculateDatePickerIndexPath(indexPathSelected: indexPath)
                    tableView.insertRows(at: [datePickerIndexPath!], with: .top)
                    tableView.endUpdates()
                    
                    // scroll to the selected row automatically after expanding the timepicker
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                }
                
                if userProfileCellData[indexPath.row].title == "ランチプラン" {
                    performSegue(withIdentifier: "showPlan", sender: self)
                    collapseDatePicker()
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                collapseDatePicker()
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // close the date picker when the user select any other items on the list
    func collapseDatePicker() {
        tableView.beginUpdates()
        if datePickerIndexPath != nil {
            tableView.deleteRows(at: [datePickerIndexPath!], with: .top)
            datePickerIndexPath = nil
        }
        tableView.endUpdates()
        
        // scroll back to show the whole list
        tableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .middle, animated: true)
    }
    
    
    func calculateDatePickerIndexPath (indexPathSelected: IndexPath) -> IndexPath {
        if datePickerIndexPath != nil && datePickerIndexPath!.row < indexPathSelected.row {
            return IndexPath(row: indexPathSelected.row, section: 0)
        } else {
            return IndexPath(row: indexPathSelected.row + 1, section: 0)
        }
    }
    
    // set the detail label on the lunch time item when the user selected a time
    @IBAction func setLunchTime(_ sender: UIDatePicker) {
        let parentIndexPath = IndexPath (row: datePickerIndexPath!.row - 1, section: 0)
        // change model
        dateFormatter.dateFormat = "HH:mm"
        lunchTimeData = dateFormatter.string(from: sender.date)
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileSettingWithDetailCell", for: parentIndexPath) as! profileSettingWithDetailCell
        cell.detail.text = lunchTimeData
        // save the user lunch time setting to cloud firestore
        let newLunchTimeData: [String: Any] = [
            "lunchTime": lunchTimeData
        ]
        docRef.setData(newLunchTimeData, merge: true, completion: { (error) in
            if let error = error {
                print ("Oh no! Got an error: \(error.localizedDescription)")
            } else {
                print ("User data has been saved")
            }
        })
        tableView.reloadData()
        
    }
    
    // MARK: Edit profile action
    func editProfilePic() {
        let pickPicActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        pickPicActionSheet.addAction(UIAlertAction(title: "写真を撮る", style: .default, handler: {(UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        pickPicActionSheet.addAction(UIAlertAction(title: "写真を選ぶ", style: .default, handler: {(UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        pickPicActionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {(UIAlertAction) in

        }))

        present(pickPicActionSheet, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userProfileCellData[0].image = image
            tableView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: unwind segue
    
    // display the chosen plan's name in the plan view controller.
    @IBAction func finishChoosingPlan (segue: UIStoryboardSegue) {
        let planVC = segue.source as! PlanTableViewController
        // receive the user option from planVC
        // update the model
        // TODO: see if it is possible to dynamic change the array number
        lunchTimeData = planVC.selectedPlanName
        tableView.reloadData()
    }
    
    // display the new user name if the user changed it in profile editing view controller.
    @IBAction func finishEditingPersonalInfo (segue: UIStoryboardSegue) {
        let profileEditingVC = segue.source as! ProfileEditingViewController
        userName = profileEditingVC.userName
        tableView.reloadData()
    }
    
    @IBAction func finishingEditingFavFood (segue: UIStoryboardSegue) {
        // unwind segue for fav food view controller
    }
    
    @IBAction func finishingEditingAllergyFood (segue: UIStoryboardSegue) {
        // unwind segue for alllergy food view controller
    }
    
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "showPlan" {
            // TODO: Delete it when made the plan table view controller to fetch data from the database
            if let navVC = segue.destination as? UINavigationController {
                let planVC = navVC.viewControllers[0] as! PlanTableViewController
                if lunchTimeData != "" {
                    planVC.selectedPlanName = lunchTimeData
                }
            }
        }
        
        if segue.identifier == "showPersonalInfo" {
            // TODO: Delete it when made the plan table view controller to fetch data from the database
            if let navVC = segue.destination as? UINavigationController {
                let profileEditingVC = navVC.viewControllers[0] as! ProfileEditingViewController
                if userProfileCellData[0].title != nil {
                    profileEditingVC.userName = userProfileCellData[0].title
                }
            }
        }
        
        if segue.identifier == "showFavFood" {
            // TODO: Delete it when made the plan table view controller to fetch data from the database
        }
        
        if segue.identifier == "showAllergyFood" {
            // TODO: Delete it when made the plan table view controller to fetch data from the database
        }
        
     }
    
}

