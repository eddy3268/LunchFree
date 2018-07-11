//
//  PlanTableViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/09/26.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  Lunch subscription plan setting view
//  ランチセットのサブスクリプションプラン設定画面

import UIKit
import Firebase

struct lunchOption {
    let lunchName: String!
    let price: String!
}

// TODO: inplement cloud firestore here and save the data to the database
class PlanTableViewController: UITableViewController {
    
    //[START def user data]
    var selectedPlanName: String?
    //[END def user data]
    
    //[START def firestore database]
    var docRef: DocumentReference!
    //[END def firestore database]
    
    var lunchPlanData = [lunchOption]()
    
    let lunchPlanCellIdentifier = "lunchPlanCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lunchPlanData = [lunchOption(lunchName: "LunchFree", price: "30000円/20食"),
                         lunchOption(lunchName: "ベジタリアン", price: "40000円/20食"),
                         lunchOption(lunchName: "ビーガン", price: "40000円/20食")]
        
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
                self.selectedPlanName = userData!["selectedPlanName"] as? String ?? ""
                // Must reload data inside the closure
                self.tableView.reloadData()
            }
        }
        
        clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lunchPlanData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: lunchPlanCellIdentifier , for: indexPath)
        
        cell.textLabel?.text = lunchPlanData[indexPath.row].lunchName
        cell.detailTextLabel?.text = lunchPlanData[indexPath.row].price
        cell.selectionStyle = .none
        
        // if the user chose a plan before, preselect the plan to display the plan selection of user
        // FIXME: the option is still selected when the user select another option
        if selectedPlanName == lunchPlanData[indexPath.row].lunchName {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryType = .checkmark
            selectedPlanName = lunchPlanData[indexPath.row].lunchName
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryType = .none
        
    }
    
    // add the notice of the plan change on the footer
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "プランの変更は今のプランが終わった後に有効になります。"
    }
    
    // MARK: nav bar button action
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func finish(_ sender: UIBarButtonItem) {
        
        // present a action sheet to ask the user if they confirm to change the plan
        let changePlanActionSheet = UIAlertController(title: nil, message: "プランを変更しますか？", preferredStyle: .actionSheet)
        changePlanActionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {(UIAlertAction) in
            
                print("Cancel button pressed")
        }))
        changePlanActionSheet.addAction(UIAlertAction(title: "変更する", style: .default, handler: {(UIAlertAction) in
            
            if self.selectedPlanName != nil {
                // def new user data
                let newSelectedPlan: [String:Any] = [
                    "selectedPlanName": self.selectedPlanName!
                ]
                
                // save the data to the path
                self.docRef.setData(newSelectedPlan, merge: true, completion: { (error) in
                    if let error = error {
                        print ("Oh no! Got an error: \(error.localizedDescription)")
                    } else {
                        print ("User data has been saved!")
                    }
                })
            }
            
            self.performSegue(withIdentifier: "finishChoosingPlan", sender: self)
        }))
        
        present(changePlanActionSheet, animated: true, completion: nil)
    }
    

}
