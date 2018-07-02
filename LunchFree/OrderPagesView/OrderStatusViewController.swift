//
//  OrderStatusViewController.swift
//  LunchFree
//
//  Created by Eddy Chan on 2017/08/06.
//  Copyright © 2017 Eddy Chan. All rights reserved.
//

import UIKit
import MapKit

class OrderStatusViewController: UIViewController {

    @IBOutlet weak var deliveryManLocationMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Fetch the delivery man data from cloud firestore and set the coordinate.
        let coordinate = CLLocationCoordinate2DMake(35.664705, 139.737813)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(coordinate, span)
        
        deliveryManLocationMapView.setRegion(region, animated: true)
        
        // customizing the frame of the mapView
        deliveryManLocationMapView.setRounded(cornerRadius: 25)
    }
    
    
    @IBAction func callDeliveryMan(_ sender: UIButton) {
        if let url = URL(string: "tel://08096670540"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

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
