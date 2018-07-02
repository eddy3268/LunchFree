//
//  NoUpcomingOrderViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/09/06.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//
//  The View when there is no current order.
//  現在進行中オーダーがない時の画面。
//

import UIKit

class NoUpcomingOrderViewController: UIViewController, UITabBarDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func orderNow(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
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
