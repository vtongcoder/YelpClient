//
//  Business.swift
//  YelpClient
//
//  Created by Dan Tong on 9/7/15.
//  Copyright © 2015 DanTong. All rights reserved.
//

import UIKit
import CoreLocation

class Business: NSObject {
  let name: String?
  let address: String?
  let imageURL: NSURL?
  let categories: String?
  let distance: String?
  let distanceMeters: NSNumber?
  let ratingImageURL: NSURL?
  let reviewCount: NSNumber?
  var longitude:  Double?
  var latitude:   Double?
  var location: CLLocation
  
  
  
  init(dictionary: NSDictionary){
    name = dictionary["name"] as? String
    
    let imageURLStr = dictionary["image_url"] as? String
    if imageURLStr != nil{
      imageURL = NSURL(string: imageURLStr!)
    } else {
      imageURL = nil
    }
    
    let location = dictionary["location"] as? NSDictionary
    var address = ""
    if location != nil {
      let addrArray = location!["address"] as? NSArray
      //            var street: String? = ""
      if addrArray != nil && addrArray?.count > 0 {
        address = addrArray![0] as! String
      }
      let neighborhoods = location!["neighborhoods"] as? NSArray
      if neighborhoods != nil && neighborhoods!.count > 0 {
        if !address.isEmpty {
          address += ","
        }
        address += neighborhoods![0] as! String
      }
    }
    self.address = address
    
    if location != nil {
      if let coordinate = location!["coordinate"] as? NSDictionary {
        self.latitude = (coordinate["latitude"] as! Double)
      }
    }
    if location != nil {
      if let coordinate = location!["coordinate"] as? NSDictionary {
        self.longitude = (coordinate["longitude"] as! Double)
      }
    }
    
    self.location = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
    
    let categoriesArray = dictionary["categories"] as? [[String]]
    if categoriesArray != nil {
      var categoryNames = [String]()
      for category in categoriesArray! {
        let categoryName = category[0]
        categoryNames.append(categoryName)
      }
      categories = categoryNames.joinWithSeparator(",")
    } else {
      categories = nil
    }
    
    distanceMeters = dictionary["distance"] as? NSNumber
    if distanceMeters != nil {
      let milesPerMeter = 0.000621371
      distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
    } else {
      distance = nil
    }
    
    let ratingImageURLString = dictionary["rating_img_url_large"] as? String
    if ratingImageURLString != nil {
      ratingImageURL = NSURL(string: ratingImageURLString!)
    } else {
      ratingImageURL = nil
    }
    reviewCount = dictionary["review_count"] as? NSNumber
    
    
    
  }
  class func businesses(array: [NSDictionary]) -> [Business] {
    var businesses = [Business]()
    for dictionary in array {
      let business = Business(dictionary: dictionary)
      businesses.append(business)
    }
    return businesses
  }
  
  class func searchWithTerm(term: String?, completion: ([Business]!, NSError!) -> Void) {
    YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
  }
  
  class func searchWithTerm(term: String?, sort: Int?, categories: [String]?, deals: Bool?, radius: Float?, completion: ([Business]!, NSError!) -> Void) -> Void {
    YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, radius: radius, completion: completion)
  }
  
}
