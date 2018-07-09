//
//  FavFoodViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/10/22.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  The View for setting favorite food
//  好きな食べ物の設定画面

import UIKit
import Firebase

class FavFoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var favFoodTableView: UITableView!
    
    var favFood: [String]?
    
    //[START def firebase database]
    var docRef: DocumentReference!
    //[END def firebase database]
    
    //[START def firebase database]
    var userDataListener: ListenerRegistration!
    //[END def firebase database]
    
    // MARK: creating the object for fav food input
    let favFoodInputContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputTextField: UITextField = {
       let textfield = UITextField()
        textfield.placeholder = "好きな食べ物を入力してください"
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
        favFoodTableView.delegate = self
        favFoodTableView.dataSource = self
        favFoodTableView.register(UITableViewCell.self, forCellReuseIdentifier: "foodItemCell")
        favFoodTableView.tableHeaderView = UIView() // delete header
        favFoodTableView.tableFooterView = UIView() // delete footer to not showing the extra cell
        
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
                self.favFood = userData!["favFood"] as? [String] ?? [""] // the default value when there is no data makes the first empty row!!! But if I dun give a default value [""] I can't make a new line
                self.favFoodTableView.reloadData()
            }
        }
        //[END fetching user data]
        
        // Add the action to the add button
        addButton.addTarget(self, action: #selector(addFavFood(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        //[START updating user data]
//        userDataListener = docRef.addSnapshotListener { (docSnapshot, error) in
//            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
//            let userData = docSnapshot.data()
//            self.favFood = userData!["favFood"] as? [String] ?? [""]
//            self.favFoodTableView.reloadData()
//        }
//        //[END updating user data]
    }
    
    func setupInputContainerView () {
        view.addSubview(favFoodInputContainerView)
        view.addContraintsWithFormat("H:|[v0]|", views: favFoodInputContainerView)
        view.addContraintsWithFormat("V:[v0(48)]", views: favFoodInputContainerView)
        bottomConstraint = NSLayoutConstraint(item: favFoodInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        //TODO: fix it for iphone X
        
    }
    
    func setupInputComponents () {
        // add a seperator to the textField bar
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        favFoodInputContainerView.addSubview(inputTextField)
        favFoodInputContainerView.addSubview(addButton)
        favFoodInputContainerView.addSubview(topBorderView)
        
        favFoodInputContainerView.addContraintsWithFormat("H:|-16-[v0][v1(60)]|", views: inputTextField, addButton)
        favFoodInputContainerView.addContraintsWithFormat("V:|[v0]|", views: inputTextField)
        favFoodInputContainerView.addContraintsWithFormat("V:|[v0]|", views: addButton)

        favFoodInputContainerView.addContraintsWithFormat("H:|[v0]|", views: topBorderView)
        favFoodInputContainerView.addContraintsWithFormat("V:|[v0(0.5)]", views: topBorderView)
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
        
        if favFood != nil {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            
            return favFood!.count
            
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
        
        cell.textLabel?.text = favFood?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: delete the item in favFood
            
            // Because there is an extra cell on the first row so have to -1
            favFood?.remove(at: indexPath.row)
            
            // delete the row on display
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func completeAddingFavFood(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        // save the favFood data to database
        if favFood != nil {
            let newFavFood: [String:Any] = [
                // def new fav food
                "favFood": favFood!
            ]
            
            // save the data to the path
            docRef.setData(newFavFood, merge: true, completion: { (error) in
                if let error = error {
                    print ("Oh no! Got an error: \(error.localizedDescription)")
                } else {
                    print ("User data has been saved")
                }
            })
        }
        
        // perform unwind segue
        performSegue(withIdentifier: "finishingEditingFavFood", sender: self)
    }
    
    
    
    @IBAction func tapToHideKeyboard(_ sender: UITapGestureRecognizer) {
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
    }
    
    @objc func addFavFood (sender: UIButton) {
        self.view.endEditing(true) // resign the first responsor in the whole page and fire the didendediting func
    }
    
    // MARK: TextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // This is the only way I can solve the initial row bug...
        if favFood == [""] {
            if let newFood = textField.text, textField.text != "" {
                favFood?.append(newFood)
                favFoodTableView.reloadData()
                favFood?.remove(at: 0)
                favFoodTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
            
        
        } else {
            if let newFood = textField.text, textField.text != "" {
                favFood?.append(newFood)
            }
        }
        
        favFoodTableView.reloadData()
        
        // clear the textField for next input
        inputTextField.text = ""
        
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
