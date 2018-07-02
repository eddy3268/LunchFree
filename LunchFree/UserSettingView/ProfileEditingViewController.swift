//
//  ProfileEditingViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/09/08.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//

struct userProfileSettingCellItem {
    let cellType: String!
    let title: String!
    var textFieldPlaceHolder: String!
}

import UIKit
import Firebase


class ProfileEditingViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
        
    var userProfileSettingCellItemList = [userProfileSettingCellItem]()
    
    var dataPickerIndexPath: IndexPath?
    
    //[START def firebase database]
    var docRef: DocumentReference!
    //[END def firebase database]
    
    //[START def user data]
    var userName: String?
    var age: String?
    var sex: String?
    var email: String?
    //[END def user data]
    
    //Row Height
    var textEnterCellRowHeight: CGFloat = 80
    var numberEnterCell: CGFloat = 80
    var dataPickerCellRowHeight: CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileSettingCellItemList = [userProfileSettingCellItem(cellType:"textEnterCell" ,title: "お名前", textFieldPlaceHolder: "お名前をカタカナかローマ字で入力してください"),
                                          userProfileSettingCellItem(cellType:"numberEnterCell" ,title: "年齢", textFieldPlaceHolder: "数字で入力してください"),
                                          userProfileSettingCellItem(cellType:"dataSelectionCell" ,title: "性別", textFieldPlaceHolder: ""),
                                          userProfileSettingCellItem(cellType:"textEnterCell" ,title: "メールアドレス", textFieldPlaceHolder: "メールアドレス入力してください")]
        
        // [START get the uid]
        let auth = Auth.auth()
        if let currentUser = auth.currentUser {
            let uid = currentUser.uid
        // [END get the uid]
            //[START fetching user data]
            docRef = Firestore.firestore().collection("users").document("\(uid)")
            docRef.getDocument { (docSnapshot, error) in
                guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
                let userData = docSnapshot.data()
                self.userName = userData!["userName"] as? String ?? ""
                self.age = userData!["age"] as? String ?? ""
                self.sex = userData!["sex"] as? String ?? ""
                self.email = userData!["email"] as? String ?? ""
            }
        }
        //[END fetching user data]
    }
    
    // MARK: tableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataPickerIndexPath != nil {
            return userProfileSettingCellItemList.count + 1
        }
        
        return userProfileSettingCellItemList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if dataPickerIndexPath != nil && dataPickerIndexPath!.row == indexPath.row {
            
            return dataPickerCellRowHeight
            
        } else if dataPickerIndexPath != nil && dataPickerIndexPath!.row + 1 == indexPath.row {
            switch userProfileSettingCellItemList[indexPath.row - 1].cellType {
            case "textEnterCell":
                return textEnterCellRowHeight
            default:
                return textEnterCellRowHeight
            }
        } else {
            
            switch userProfileSettingCellItemList[indexPath.row].cellType {
            case "textEnterCell":
                
                return textEnterCellRowHeight
                
            case "numberEnterCell":
                
                return numberEnterCell
                
            default:
                
                return textEnterCellRowHeight
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataPickerIndexPath != nil && dataPickerIndexPath!.row == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataPickerCell") as! DataPickerCell
            
            // Set the initial option of the picker. Commentted out for testing the UX of selecting data
            // cell.dataPicker.selectRow(0, inComponent: 0, animated: true)
            
            return cell
            
        }
            // When the dataPicker is expanding and the row that creating is under the expanded datapicker
        else if dataPickerIndexPath != nil && dataPickerIndexPath!.row + 1 == indexPath.row {
            
            switch userProfileSettingCellItemList[indexPath.row - 1].cellType {
                
            case "textEnterCell":
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileSettingCell", for: indexPath) as! ProfileEditingTableViewCell
                
                cell.profileEditingItemTextField.tag = indexPath.row
                
                cell.profileEditingItemTitle.text = userProfileSettingCellItemList[indexPath.row - 1].title
                cell.profileEditingItemTextField.placeholder = userProfileSettingCellItemList[indexPath.row - 1].textFieldPlaceHolder
                
                // configure the keyboard
                if userProfileSettingCellItemList[indexPath.row - 1].title == "メールアドレス" {
                    cell.profileEditingItemTextField.keyboardType = .emailAddress
                } else {
                    cell.profileEditingItemTextField.keyboardType = .namePhonePad
                }
                
                cell.profileEditingItemTextField.autocorrectionType = .no
                cell.profileEditingItemTextField.returnKeyType = .done
                
                // configure the cell style
                cell.selectionStyle = .none
                
                return cell

            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileSettingCell", for: indexPath) as! ProfileEditingTableViewCell
                
                cell.profileEditingItemTextField.tag = indexPath.row
                
                cell.profileEditingItemTitle.text = userProfileSettingCellItemList[indexPath.row].title
                cell.profileEditingItemTextField.placeholder = userProfileSettingCellItemList[indexPath.row].textFieldPlaceHolder
                
                // configure the keyboard
                if userProfileSettingCellItemList[indexPath.row].title == "メールアドレス" {
                    cell.profileEditingItemTextField.keyboardType = .emailAddress
                } else {
                    cell.profileEditingItemTextField.keyboardType = .namePhonePad
                }
                
                cell.profileEditingItemTextField.autocorrectionType = .no
                cell.profileEditingItemTextField.returnKeyType = .done
                
                // configure the cell style
                cell.selectionStyle = .none
                
                return cell
            }
            
        }
            
        else {
            
            switch userProfileSettingCellItemList[indexPath.row].cellType {
            case "textEnterCell":
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileSettingCell", for: indexPath) as! ProfileEditingTableViewCell
                
                // display info on the cell
                cell.profileEditingItemTitle.text = userProfileSettingCellItemList[indexPath.row].title
                cell.profileEditingItemTextField.tag = indexPath.row
                if self.userName != nil {
                    cell.profileEditingItemTextField.placeholder = self.userName
                    cell.profileEditingItemTextField.textColor = .black
                } else {
                    cell.profileEditingItemTextField.placeholder = userProfileSettingCellItemList[indexPath.row].textFieldPlaceHolder
                }
                
                
                // configure the keyboard
                if userProfileSettingCellItemList[indexPath.row].title == "メールアドレス" {
                    cell.profileEditingItemTextField.keyboardType = .emailAddress
                } else {
                    cell.profileEditingItemTextField.keyboardType = .namePhonePad
                }
                
                cell.profileEditingItemTextField.autocorrectionType = .no
                cell.profileEditingItemTextField.returnKeyType = .done
                
                cell.selectionStyle = .none
                
                return cell
                
                
            case "numberEnterCell":
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileSettingCell", for: indexPath) as! ProfileEditingTableViewCell
                cell.profileEditingItemTextField.tag = indexPath.row
                cell.profileEditingItemTitle.text = userProfileSettingCellItemList[indexPath.row].title
                cell.profileEditingItemTextField.placeholder = userProfileSettingCellItemList[indexPath.row].textFieldPlaceHolder
                cell.profileEditingItemTextField.keyboardType = .numberPad
                
                // Create a toolbar for the num pad
                let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
                // create left side empty space so that done button set on right side
                let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ProfileEditingViewController.doneButtonAction))
                toolbar.setItems([flexSpace, doneBtn], animated: false)
                toolbar.sizeToFit()
                
                // set up the toolbar to the keyboard
                cell.profileEditingItemTextField.inputAccessoryView = toolbar
                
                cell.selectionStyle = .none
                
                return cell
                
            case "dataSelectionCell":
                
                let dataSelectionCell = tableView.dequeueReusableCell(withIdentifier: "dataSelectionCell", for: indexPath) as! DataSelectionCell
                
                dataSelectionCell.title.text = userProfileSettingCellItemList[indexPath.row].title
                dataSelectionCell.detail.text = userProfileSettingCellItemList[indexPath.row].textFieldPlaceHolder
                
                return dataSelectionCell
                
            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileSettingCell", for: indexPath) as! ProfileEditingTableViewCell
                
                cell.profileEditingItemTitle.text = userProfileSettingCellItemList[indexPath.row].title
                cell.profileEditingItemTextField.placeholder = userProfileSettingCellItemList[indexPath.row].textFieldPlaceHolder
                
                cell.selectionStyle = .none
                
                return cell
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dataPickerIndexPath != nil && dataPickerIndexPath!.row == indexPath.row {
            
            var parentIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            
            switch userProfileSettingCellItemList[parentIndexPath.row].cellType {
                
            case "textEnterCell":
                collapseDataPicker()
                tableView.deselectRow(at: parentIndexPath, animated: true)
                
            default:
                collapseDataPicker()
                tableView.deselectRow(at: parentIndexPath, animated: true)
            }
            
        } else {
            switch userProfileSettingCellItemList[indexPath.row].cellType {
            case "textEnterCell":
                collapseDataPicker()
                tableView.deselectRow(at: indexPath, animated: true)
                
            case "dataSelectionCell":
                if dataPickerIndexPath != nil {
                    collapseDataPicker()
                } else {
                    tableView.beginUpdates()
                    dataPickerIndexPath = calculateDataPickerindexPath(indexPathSelected: indexPath)
                    tableView.insertRows(at: [dataPickerIndexPath!], with: .top)
                    tableView.endUpdates()
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                collapseDataPicker()
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        }
    }
    
    
    func collapseDataPicker() {
        tableView.beginUpdates()
        if dataPickerIndexPath != nil {
            tableView.deleteRows(at: [dataPickerIndexPath!], with: .top)
            dataPickerIndexPath = nil
        }
        tableView.endUpdates()
        
    }
    
    func calculateDataPickerindexPath (indexPathSelected: IndexPath) -> IndexPath {
        if dataPickerIndexPath != nil && dataPickerIndexPath!.row < indexPathSelected.row {
            return IndexPath(row: indexPathSelected.row, section: 0)
        } else {
            return IndexPath(row: indexPathSelected.row + 1, section: 0)
        }
    }
    
    
    // MARK: nav bar button action
    @IBAction func cancelEditing(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeEditing (_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        if userName != nil || sex != nil || age != nil || email != nil {
            // save new user data to firebase
            let newUserData: [String:Any] = [
                "userName": userName!,
                "sex": sex!,
                "age": age!,
                "email": email!
            ]
            
            // save the data to the path
            docRef.setData(newUserData, merge: true,  completion: { (error) in
                if let error = error {
                    print("Oh no! Got an error: \(error.localizedDescription)")
                } else {
                    print("User data has been saved!")
                }
            })
        }
        
        performSegue(withIdentifier: "finishEditingPersonalInfo", sender: self)
        print("finishingEditingpersoonalInfo called")
    }
    
    
    // MARK: textField delegate and keyboard action
    
    // The action of the done button on the keyborad
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //save the new name
        switch textField.tag {
        case 0:
            if let newUserName = textField.text {
                // save for the display in user setting screen
                userName = newUserName
                print("userName set")
            }
        case 1:
            if let newUserAge = textField.text {
                // save the new age
                age = newUserAge
                print("userName set")
            }
            
        // case 2 is the sex selection cell so skip it
            
        case 2:
            break
        
        case 3:
            if let newEmail = textField.text {
                // save the new age
                email = newEmail
                print("email set")
            }
            
        default:
            break
        }
        
    }
    
        
    // MARK: Setting for picker view
        
    let pickerViewDataList = ["男", "女"]
    
    // "Component" is how many picker you have in ONE view. Use it when you need user to have different combination of choices
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewDataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // save the user data
        sex = pickerViewDataList[row]
        
        // get the indexpath of the parent cell
        let parentindexPath = IndexPath(row: dataPickerIndexPath!.row - 1, section: 0)
        
        // update the view
        userProfileSettingCellItemList[parentindexPath.row].textFieldPlaceHolder = sex
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataSelectionCell", for: parentindexPath) as! DataSelectionCell
        cell.detail.textColor = .black
        tableView.reloadData()
        
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
