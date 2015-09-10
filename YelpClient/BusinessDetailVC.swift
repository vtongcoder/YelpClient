//
//  BusinessDetailVC.swift
//  YelpClient
//
//  Created by Dan Tong on 9/8/15.
//  Copyright © 2015 DanTong. All rights reserved.
//

import UIKit
import MapKit
class BusinessDetailVC: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var thumbImage: UIImageView!
  @IBOutlet weak var ratingImage: UIImageView!
  @IBOutlet weak var reviewsLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  
  @IBOutlet weak var mapView: MKMapView!
  
  var selectedBusiness: Business!
  var userLocation: UserLocation = UserLocation()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initMapView()
    self.title = selectedBusiness.name
    thumbImage.setImageWithURL(selectedBusiness.imageURL)
    ratingImage.setImageWithURL(selectedBusiness.ratingImageURL)
    reviewsLabel.text = "\(selectedBusiness.reviewCount!) views"
    addressLabel.text = selectedBusiness.address
    categoryLabel.text = selectedBusiness.categories
    distanceLabel.text  = selectedBusiness.distance! + String(format: " (%.2f km)", ((selectedBusiness.distanceMeters! as Float)/1000))
//    let distance = self.selectedBusiness.location.distanceFromLocation(self.userLocation.location)
//    self.distanceLabel.text = String(format: "%.1f mi", distance / 1609.344)
    self.distanceLabel.sizeToFit()

    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func initMapView(){
    self.mapView.delegate = self
    // 1
    let location = CLLocationCoordinate2D(
      latitude: self.selectedBusiness.latitude!,
      longitude: self.selectedBusiness.longitude!
    )
    // 2
    let span = MKCoordinateSpanMake(0.05, 0.05)
    let region = MKCoordinateRegion(center: location, span: span)
    mapView.setRegion(region, animated: true)
    
    //3
    let annotation = MKPointAnnotation()
    annotation.coordinate = location
//    annotation.title = "Big Ben"
//    annotation.subtitle = "London"
    mapView.addAnnotation(annotation)
    self.mapView.setRegion(region, animated: true)
    
  }
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if !(annotation is MKPointAnnotation) {
      return nil
    }
    
    var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
    if view == nil {
      view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
      view!.canShowCallout = false
    }
    return view
  }
  
}
