//
//  BusinessDetailVC.swift
//  YelpClient
//
//  Created by Dan Tong on 9/8/15.
//  Copyright © 2015 DanTong. All rights reserved.
//

import UIKit
import MapKit
class BusinessDetailVC: UIViewController {

  @IBOutlet weak var thumbImage: UIImageView!
  @IBOutlet weak var businessName: UILabel!
  
  @IBOutlet weak var mapView: MKMapView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMapView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func initMapView(){
    // 1
    let location = CLLocationCoordinate2D(
      latitude: 51.50007773,
      longitude: -0.1246402
    )
    // 2
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegion(center: location, span: span)
    mapView.setRegion(region, animated: true)
    
    //3
    let annotation = MKPointAnnotation()
    annotation.coordinate = location
    annotation.title = "Big Ben"
    annotation.subtitle = "London"
    mapView.addAnnotation(annotation)
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
