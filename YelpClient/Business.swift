//
//  Business.swift
//  YelpClient
//
//  Created by Dan Tong on 9/7/15.
//  Copyright © 2015 DanTong. All rights reserved.
//

import UIKit

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let reviewCount: NSNumber?
    
    init(dictionanry: NSDictionary){
        name = dictionanry["name"] as? String
        let imageURLStr = dictionanry["image_url"] as? String
        if imageURLStr != nil{
            imageURL = NSURL(string: imageURLStr!)
        } else {
            imageURL = nil
        }
        
        let location = dictionanry["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addrArray = location!["address"] as? NSArray
            var street: String? = ""
            if addrArray != nil && addrArray?.count > 0 {
                address = addrArray![0] as! String
            }
            let neighborhood = location["neighborhoods"] as? NSArray
            
            
        }
        
        
        
    }
}
