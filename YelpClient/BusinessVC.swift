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
  var filters = [String : AnyObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.sizeToFit()
    searchBar.placeholder = "Restaurant"
    searchBar.delegate = self
    navigationItem.titleView = searchBar
    
    
    yelpTableView.rowHeight = UITableViewAutomaticDimension
    yelpTableView.estimatedRowHeight = 120
    
    Business.searchWithTerm("Restaurants", sort: nil, categories: ["asianfusion", "burgers"], deals: true, radius: nil) { (businesses: [Business]!, error: NSError!) -> Void in
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
    //    let navigationController = segue.destinationViewController as! UINavigationController
    if sender is UIBarButtonItem {
      let navigationController = segue.destinationViewController as! UINavigationController
      let filtersViewController = navigationController.topViewController as! FiltersVC
      filtersViewController.delegate = self
    } else {
      let detailViewController = segue.destinationViewController as! BusinessDetailVC
      var indexPath: AnyObject!
      indexPath = yelpTableView.indexPathForCell(sender as! UITableViewCell)
      detailViewController.selectedBusiness = businesses[indexPath!.row]
    }

  }
  func filtersVC(filtersVC: FiltersVC, didUpdateFilters filters: [String : AnyObject]) {
    var term: String?
    if !searchBar.text!.isEmpty {
      term = searchBar.text
      self.filters["term"] = term
    } else {
      term = nil
    }
    let categories = filters["categories"] as? [String]
    let sort = filters["sort"] as? Int
    let deal = filters["deal"] as? Bool
    let radius = filters["radius"] as! Float?
    // Update for filters in this VC
    // Set filters in this view controller
    self.filters["sort"] = sort
    self.filters["categories"] = categories
    self.filters["deal"] = deal
    self.filters["radius"] = radius
    
    
    //    Business.searchWithTerm(term!, sort: sort, categories: categories, deals: deal, radius: radius) { (businesses: [Business]!, error: NSError!) -> Void in
    //      self.businesses = businesses
    //      self.yelpTableView.reloadData()
    //    }
    Business.searchWithTerm(term , sort: sort, categories: categories, deals: deal, radius: radius) { (businesses: [Business]!, error: NSError!) -> Void in
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
    let sort = filters["sort"] as? Int
    let categories = self.filters["categories"] as? [String]
    let deal = self.filters["deal"] as? Bool
    let radius = self.filters["radius"] as! Float?
    
    if term != nil {
    Business.searchWithTerm(term!, sort: sort, categories: categories, deals: deal, radius: radius) { (businesses : [Business]!, error: NSError!) -> Void in
      if error == nil {
        self.businesses = businesses
        if self.businesses.count == 0 {
          self.searchNoResultAlert()
          self.yelpTableView.hidden = true
        } else {
          self.yelpTableView.hidden = false
          self.yelpTableView.reloadData()
        }
      } else {
        print("Search Error: \(error.description)")
      }
    }
    }
    
  }
  func searchNoResultAlert(){
    let actionSheetController: UIAlertController = UIAlertController(title: "Searching❗️", message: "No Search Result found.Try with another. Thank you!", preferredStyle: .Alert)
    let okButton: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) {action -> Void in
      //      self.loadingIndicator.stopAnimating()
    }
    actionSheetController.addAction(okButton)
    self.presentViewController(actionSheetController, animated: true, completion: nil)
  }
}
