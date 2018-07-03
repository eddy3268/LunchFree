//
//  FirstViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/08/03.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  This View Controller is the main screen of the LunchFree App.
//  This Screen let the user to choose the daily recommended lunch set in the subscription plan with just 2 taps.
//  The app is not organized as MVC pattern which will be my next task to organize it...
//
//  LunchFreeのメイン画面。
//  ユーザーは2タップだけで日替わりのおすすめランチセットを注文することができる。
//  MVCパターンになっていなくて、リファクタリングもしなくて、コードが分かりづらくても申し訳ございません...次のタスクとしてまとめます。
//

import UIKit
import Firebase
import FirebaseUI

class MealViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,FUIAuthDelegate {
    
    @IBOutlet weak var lunchSetPicView: UIImageView!
    @IBOutlet weak var lunchOptionCollectionView: UICollectionView!
    
    
    // To use Firebase Auth on this app, it requires to register google api key, facebook app id and twitter app id on info.plist.
    // このアプリでfirebase authのログイン機能をテストするには、google api keyと、facebook app idと、twitter app id を info.plistに登録する必要がある。
    //[START def Firebase Auth and Firebase Auth UI]
    var auth: Auth?
    var authUI: FUIAuth?
    //[END def Firebase Auth UI]
    
    //[START def auth state change listener]
    var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    //[END def auth state change listener]
    
    //[START def firebase database]
    var docRef: DocumentReference!
    //[END def firebase database]
    
    var isUserPlacingOrder = Bool()
    
    var dataList = [restaurantlunchData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure inside viewdidload to make sure FirebaseApp.configure happens first
        // before all the other component configure itself.
        //[START configure Firebase Auth]
        auth = Auth.auth()
        authUI = FUIAuth.defaultAuthUI()
        auth?.languageCode = "jp"
        //[END configure Firebase Auth]
        
        //set the delegate of authUI to self
        authUI?.delegate = self
        
        //[START configurate the type of FireBase Auth UI]
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            FUITwitterAuth(),
            ]
        
        self.authUI?.providers = providers
        //[END configurate the type of FireBase Auth UI]
        
        // Force signout. For debugging AuthUI. Del later
//        do {
//            try auth?.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
        
        authStateListenerHandle = auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                // if the user is not signed in, show the login VC to let the user login or signup
                self.showLoginView()
                return
            }
            
        }
        
        // data list for the recommendation lunch set
        dataList = [restaurantlunchData(lunchSetName: "京野菜定食", restaurantName: "〇〇野菜キッチン", image: #imageLiteral(resourceName: "lunchSetSample")),
                    restaurantlunchData(lunchSetName: "タコス定食", restaurantName: "アメリカンソウルフード", image: #imageLiteral(resourceName: "lunchSetSample2")),
                    restaurantlunchData(lunchSetName: "三元豚とんかつ定食", restaurantName: "〇〇屋", image: #imageLiteral(resourceName: "lunchASetSample3")),]
        
        // set the the first option's image as the initial image of the big image view on the meal view
        lunchSetPicView.image = dataList[0].image
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lunchOptionCollectionViewCell", for: indexPath) as! LunchOptionCollectionViewCell
        
        cell.restaurantImageView.image = dataList[indexPath.item].image
        cell.lunchSetNameLabel.text = dataList[indexPath.item].lunchSetName
        cell.restaurantNameLabel.text = dataList[indexPath.item].restaurantName
        
        return cell
    }
    
    
    // Trying to moving the selected cell to the center to indicate the selected option
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth = 250 * dataList.count
//        let totalSpacingWidth = 10 * (dataList.count - 1)
//
//        let leftInset = (375 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        collectionView.scrollToItem(at: context.nextFocusedIndexPath!, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lunchSetPicView.image = dataList[indexPath.item].image
        print("the user selected the " + "\(indexPath.item)" + " option")
        
    }
    
    @IBAction func placeOrder(_ sender: UIButton) {
        let placeOrderActionSheet = UIAlertController(title: nil, message: "注文しますか？", preferredStyle: .actionSheet)
        
        placeOrderActionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (UIAlertAction) in
            print("Cancel button pressed")
        }))
        placeOrderActionSheet.addAction(UIAlertAction(title: "注文する", style: .default, handler: { (UIAlertAction) in
            // TODO: capture and save the order and user information (i.e. which lunch set did the user select, user name, location, order time, deliverary time...) send the order and user information to the database
            print("Order button pressed")
            
            // show the order status page on the order tag
            // FIXME: once the order view controller is created BEFORE pressing the order button on other tag, it cannot change the view to order status even the order button is pressed.
            
            // switch the order status screen to display the current order status and detail
            let navVC = self.tabBarController?.viewControllers?[2] as! UINavigationController
            let orderVC = navVC.topViewController as! OrderViewController
            self.isUserPlacingOrder = true
            orderVC.isUpcomingOrder = self.isUserPlacingOrder
            
            // send the user to the order status screen
            self.tabBarController?.selectedIndex = 2
            
        }))
        
        present(placeOrderActionSheet, animated: true, completion: nil)
        
    }
    
    // check if user is signed in
    private func isUserSignedIn() -> Bool {
        return auth?.currentUser != nil
    }
    
    // show the login screen
    private func showLoginView() {
        if let authVC = authUI?.authViewController() {
            present(authVC, animated: true, completion: nil)
        }
    }
    
    // MARK: action after signin
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // if the user is a new user, then create a profile in the database and save the user id, user name and email address.
        // It doesn't necessary to do this but doing this can reducce the time to call the Firebase Auth for user info.
        // and it also better to organize user info in one database with other info and preferences.
        if (authDataResult?.additionalUserInfo?.isNewUser)! {
            let currentUser = auth?.currentUser
            let uid = currentUser!.uid
            let userName = currentUser!.displayName
            let email = currentUser!.email
            let userData: [String:Any] = [
                "userID": uid,
                "userName": userName!,
                "email": email!,
                ]
            
            // writing data to cloud Firestore
            // creating a document ref path with the name of the user id
            docRef = Firestore.firestore().collection("users").document("\(uid)")
            // save the data to the path
            docRef.setData(userData, completion: { (error) in
                if let error = error {
                    print("Oh no! Got an error: \(error.localizedDescription)")
                } else {
                    print("User data has been saved!")
                }
            })
        }
        
        // catch the error of login
        guard let authError = error else { return }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)")
        }
    }
}

