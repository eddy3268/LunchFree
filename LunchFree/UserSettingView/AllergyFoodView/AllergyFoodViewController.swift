//
//  AllergyFoodViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2018/07/01.
//  Copyright © 2018 Eddy Chan. All rights reserved.
//
//  The View for setting allergy food
//  アレルギーの食べ物の設定画面

import UIKit
import Firebase

class AllergyFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var allergyFoodTableView: UITableView!
    
    var allergyFood: [String]?
    
    //[START def firebase database]
    var docRef: DocumentReference!
    //[END def firebase database]
    
    //[START def firebase database]
    var userDataListener: ListenerRegistration!
    //[END def firebase database]
    
    // MARK: creating the object for allergy food input
    let allergyFoodInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "アレルギーの食べ物を入力してください"
        return textfield
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("＋", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the tableView
        allergyFoodTableView.delegate = self
        allergyFoodTableView.dataSource = self
        allergyFoodTableView.register(UITableViewCell.self, forCellReuseIdentifier: "foodItemCell")
        allergyFoodTableView.tableHeaderView = UIView() // delete header
        allergyFoodTableView.tableFooterView = UIView() // delete footer to not showing the extra cell
        
        // Set the textField
        inputTextField.delegate = self
        
        // Do any additional setup after loading the view.
        setupInputContainerView()
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
        
        
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
                self.allergyFood = userData!["allergyFood"] as? [String] ?? [""] // the default value when there is no data makes the first empty row!!! But if I dun give a default value [""] I can't make a new line
            }
        }
        //[END fetching user data]
        
        // Add the action to the add button
        addButton.addTarget(self, action: #selector(addAllergyFood(sender:)), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        //[START updating user data]
        //        userDataListener = docRef.addSnapshotListener { (docSnapshot, error) in
        //            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
        //            let userData = docSnapshot.data()
        //            self.allergyFood = userData!["allergyFood"] as? [String] ?? [""]
        //            self.allergyFoodTableView.reloadData()
        //        }
        //        //[END updating user data]
    }
    
    func setupInputContainerView () {
        view.addSubview(allergyFoodInputContainerView)
        view.addContraintsWithFormat("H:|[v0]|", views: allergyFoodInputContainerView)
        view.addContraintsWithFormat("V:[v0(48)]", views: allergyFoodInputContainerView)
        bottomConstraint = NSLayoutConstraint(item: allergyFoodInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        //TODO: fix it for iphone X
        
    }
    
    func setupInputComponents () {
        
        // add a seperator to the textField bar
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        allergyFoodInputContainerView.addSubview(inputTextField)
        allergyFoodInputContainerView.addSubview(addButton)
        allergyFoodInputContainerView.addSubview(topBorderView)
        
        allergyFoodInputContainerView.addContraintsWithFormat("H:|-16-[v0][v1(60)]|", views: inputTextField, addButton)
        allergyFoodInputContainerView.addContraintsWithFormat("V:|[v0]|", views: inputTextField)
        allergyFoodInputContainerView.addContraintsWithFormat("V:|[v0]|", views: addButton)
        
        allergyFoodInputContainerView.addContraintsWithFormat("H:|[v0]|", views: topBorderView)
        allergyFoodInputContainerView.addContraintsWithFormat("V:|[v0(0.5)]", views: topBorderView)
    }
    
    // handling the action when the keyboard pops out
    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.cgRectValue.height: 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {self.view.layoutIfNeeded()}, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if allergyFood != nil {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            
            return allergyFood!.count
            
        } else {
            // Set the empty message view
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "登録したものがありません"
            noDataLabel.font = UIFont.systemFont(ofSize: 25)
            noDataLabel.textColor = .gray
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
            
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell", for: indexPath)
        
        cell.textLabel?.text = allergyFood?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: delete the item in allergyFood
            
            // Because there is an extra cell on the first row so have to -1
            allergyFood?.remove(at: indexPath.row)
            
            // delete the row on display
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func completeAddingAllergyFood(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        // TODO: write to the database
        
        // set unwind segue
        performSegue(withIdentifier: "finishingEditingAllergyFood", sender: self)
        
    }
    
    @IBAction func tapToHideKeyboard(_ sender: UITapGestureRecognizer) {
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
    }
    
    @objc func addAllergyFood (sender: UIButton) {
        self.view.endEditing(true) // resign the first responsor in the whole page and fire the didendediting func
    }
    
    // MARK: TextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // This is the only way I can solve the initial row bug...
        if allergyFood == [""] {
            if let newFood = textField.text, textField.text != "" {
                allergyFood?.append(newFood)
                allergyFoodTableView.reloadData()
                allergyFood?.remove(at: 0)
                allergyFoodTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
            
            
        } else {
            if let newFood = textField.text, textField.text != "" {
                allergyFood?.append(newFood)
            }
        }
        
        allergyFoodTableView.reloadData()
        
        // clear the textField for next input
        inputTextField.text = ""
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
