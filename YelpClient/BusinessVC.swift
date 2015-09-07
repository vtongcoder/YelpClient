//
//  BusinessVC.swift
//  YelpClient
//
//  Created by Dan Tong on 9/7/15.
//  Copyright © 2015 DanTong. All rights reserved.
//

import UIKit

class BusinessVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var businesses: [Business]!
    @IBOutlet weak var yelpTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yelpTableView.rowHeight = UITableViewAutomaticDimension
        yelpTableView.estimatedRowHeight = 120
        /*
        Business.searchWithTerm("Thai", completion: { (businesses : [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.yelpTableView.reloadData()
        })
*/
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.yelpTableView.reloadData()
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses![indexPath.row]
        return cell
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
