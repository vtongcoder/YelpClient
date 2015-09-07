//
//  BusinessVC.swift
//  YelpClient
//
//  Created by Dan Tong on 9/7/15.
//  Copyright © 2015 DanTong. All rights reserved.
//

import UIKit

class BusinessVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersVCDelegate, UISearchBarDelegate {
  var businesses: [Business]!
  @IBOutlet weak var yelpTableView: UITableView!
  let searchBar = UISearchBar()
  var searchActive = false
  var searchBarFilter: [Business]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.sizeToFit()
    searchBar.placeholder = "Restaurant"
    searchBar.delegate = self
    navigationItem.titleView = searchBar
    
    
    yelpTableView.rowHeight = UITableViewAutomaticDimension
    yelpTableView.estimatedRowHeight = 120
    
    Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.yelpTableView.reloadData()
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
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let navigationController = segue.destinationViewController as! UINavigationController
    let filtersVC = navigationController.topViewController as! FiltersVC
    filtersVC.delegate = self
    
  }
  func filtersVC(filtersVC: FiltersVC, didUpdateFilters filters: [String : AnyObject]) {
    
    let categories = filters["categories"] as? [String]
    
    Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.yelpTableView.reloadData()
    }
  }
  // SearchBar
  
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    
    searchBar.enablesReturnKeyAutomatically = true
//    searchBar.showsCancelButton = true
  }
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    self.searchBar.endEditing(true)
    self.searchBusisness()
  }
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    self.searchBar.endEditing(true)
  }
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    self.searchBar.endEditing(true)
  }
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchBusisness()
  }
  func searchBusisness() {
    
    var term: String?
    if !searchBar.text!.isEmpty {
      term = searchBar.text
    }
    
//    let sort = filters["sort"] as? Int
//    let categories = self.filters["categories"] as? [String]
//    let deal = self.filters["deal"] as? Bool
//    let radius = self.filters["radius"] as! Float?
//    let offset = businesses.count
    
    Business.searchWithTerm(term!, sort: nil, categories: nil, deals: nil) { (businesses : [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.yelpTableView.reloadData()
      
    }

  }
  
}
