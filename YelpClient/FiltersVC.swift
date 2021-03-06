//
//  FiltersVC.swift
//  YelpClient
//
//  Created by Dan Tong on 9/7/15.
//  Copyright © 2015 DanTong. All rights reserved.
//

import UIKit

@objc protocol FiltersVCDelegate{
  optional func filtersVC(filtersVC: FiltersVC, didUpdateFilters filters: [String: AnyObject])
  
}

class FiltersVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
  
  @IBOutlet weak var filtersTableView: UITableView!
  var categories:[[String:String]] = []
  var switchStates = [Int:Bool]()
  var delegate: FiltersVCDelegate?
  var radiusRage: [Float?]!
  var filters = [String:AnyObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.filtersTableView.rowHeight = UITableViewAutomaticDimension
    
    categories = yelpCategories()
    radiusRage = [nil, 0.5, 1, 5, 10]
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onCancel(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  @IBAction func onSearch(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
    
    
    var selectedCategories = [String]()
    for (row, isSelected) in switchStates {
      if isSelected {
        selectedCategories.append(categories[row]["code"]!)
      }
      if selectedCategories.count > 0 {
        filters["categories"] = selectedCategories
      }
    }
    delegate?.filtersVC?(self, didUpdateFilters: filters)
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return radiusRage.count
    case 2:
      return 3
    case 3:
      return categories.count + 1
    case 4:
      return 1
    default:
      break
    }
    return 0
    
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    switch indexPath.section {
    case 0:
      // Deal
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      cell.switchLabel.text = "Offering a Deal"
      cell.delegate = self
      return cell
    case 1:
      // Radius
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      // Set label for each cell
      if indexPath.row == 0 {
        cell.switchLabel.text = "Auto"
      } else {
        if radiusRage[indexPath.row] == 1 {
          cell.switchLabel.text =  String(format: "%0.1f", radiusRage[indexPath.row]!) + " mile"
        } else {
          cell.switchLabel.text =  String(format: "%0.1f", radiusRage[indexPath.row]!) + " miles"
        }
      }
      cell.mySwitch.on = switchStates[indexPath.row] ?? false
      cell.delegate = self
      return cell
    case 2:
      // Sort
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      switch indexPath.row {
      case 0:
        cell.switchLabel.text = "Best Match"
      case 1:
        cell.switchLabel.text = "Distance"
      case 2:
        cell.switchLabel.text = "Rating"
      default:
        break
      }
      cell.mySwitch.on = switchStates[indexPath.row] ?? false
      cell.delegate = self
      return cell
      
    case 3:
      // Category area
      let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
      cell.switchLabel.text = categories[indexPath.row]["name"]
      cell.delegate = self
      cell.mySwitch.on = switchStates[indexPath.row] ?? false
      cell.delegate = self
      return cell
      
    default:
      let cell = UITableViewCell()
      return cell
    }
    
    
  }
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    case 1:
      for var rowIndex = 0; rowIndex < 3; rowIndex++ {
        if indexPath.row != rowIndex {
          let cell = tableView.cellForRowAtIndexPath(indexPath) as! SwitchCell
          cell.mySwitch.on = false
        }
      }
    default: break
      
    }
  }
  // MARK - TableView Section
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 4
  }
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return  "Deal"
    case 1:
      return "Radius"
    case 2:
      return  "Sort By"
    case 3:
      return  "Category"
    default:
      return nil
    }
  }
  
  func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
    let indexPath = filtersTableView.indexPathForCell(switchCell)!
    switch indexPath.section {
    case 0:
      self.filters["deal"] = value
      print("Selected deal: \(value)")
    case 1:
      if indexPath.row == 0 {
        self.filters["radius"] = nil
      }
      else {
        self.filters["radius"] = radiusRage[indexPath.row]
      }
      print("Selected Radius at: \(value)")
    case 2:
      self.filters["sort"] = indexPath.row // BestMatched = 0, Distance, HighestRated
      print("Selected Sort at: \(indexPath.row)")
    case 3:
      switchStates[indexPath.row] = value
      print("Selected category:\(indexPath.row)")
    default:
      break
    }
  }
  
  func yelpCategories() -> [[String:String]]{
    return [["name" : "Afghan", "code": "afghani"],
      ["name" : "African", "code": "african"],
      ["name" : "American, New", "code": "newamerican"],
      ["name" : "American, Traditional", "code": "tradamerican"],
      ["name" : "Arabian", "code": "arabian"],
      ["name" : "Argentine", "code": "argentine"],
      ["name" : "Armenian", "code": "armenian"],
      ["name" : "Asian Fusion", "code": "asianfusion"],
      ["name" : "Asturian", "code": "asturian"],
      ["name" : "Australian", "code": "australian"],
      ["name" : "Austrian", "code": "austrian"],
      ["name" : "Baguettes", "code": "baguettes"],
      ["name" : "Bangladeshi", "code": "bangladeshi"],
      ["name" : "Barbeque", "code": "bbq"],
      ["name" : "Basque", "code": "basque"],
      ["name" : "Bavarian", "code": "bavarian"],
      ["name" : "Beer Garden", "code": "beergarden"],
      ["name" : "Beer Hall", "code": "beerhall"],
      ["name" : "Beisl", "code": "beisl"],
      ["name" : "Belgian", "code": "belgian"],
      ["name" : "Bistros", "code": "bistros"],
      ["name" : "Black Sea", "code": "blacksea"],
      ["name" : "Brasseries", "code": "brasseries"],
      ["name" : "Brazilian", "code": "brazilian"],
      ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
      ["name" : "British", "code": "british"],
      ["name" : "Buffets", "code": "buffets"],
      ["name" : "Bulgarian", "code": "bulgarian"],
      ["name" : "Burgers", "code": "burgers"],
      ["name" : "Burmese", "code": "burmese"],
      ["name" : "Cafes", "code": "cafes"],
      ["name" : "Cafeteria", "code": "cafeteria"],
      ["name" : "Cajun/Creole", "code": "cajun"],
      ["name" : "Cambodian", "code": "cambodian"],
      ["name" : "Canadian", "code": "New)"],
      ["name" : "Canteen", "code": "canteen"],
      ["name" : "Caribbean", "code": "caribbean"],
      ["name" : "Catalan", "code": "catalan"],
      ["name" : "Chech", "code": "chech"],
      ["name" : "Cheesesteaks", "code": "cheesesteaks"],
      ["name" : "Chicken Shop", "code": "chickenshop"],
      ["name" : "Chicken Wings", "code": "chicken_wings"],
      ["name" : "Chilean", "code": "chilean"],
      ["name" : "Chinese", "code": "chinese"],
      ["name" : "Comfort Food", "code": "comfortfood"],
      ["name" : "Corsican", "code": "corsican"],
      ["name" : "Creperies", "code": "creperies"],
      ["name" : "Cuban", "code": "cuban"],
      ["name" : "Curry Sausage", "code": "currysausage"],
      ["name" : "Cypriot", "code": "cypriot"],
      ["name" : "Czech", "code": "czech"],
      ["name" : "Czech/Slovakian", "code": "czechslovakian"],
      ["name" : "Danish", "code": "danish"],
      ["name" : "Delis", "code": "delis"],
      ["name" : "Diners", "code": "diners"],
      ["name" : "Dumplings", "code": "dumplings"],
      ["name" : "Eastern European", "code": "eastern_european"],
      ["name" : "Ethiopian", "code": "ethiopian"],
      ["name" : "Fast Food", "code": "hotdogs"],
      ["name" : "Filipino", "code": "filipino"],
      ["name" : "Fish & Chips", "code": "fishnchips"],
      ["name" : "Fondue", "code": "fondue"],
      ["name" : "Food Court", "code": "food_court"],
      ["name" : "Food Stands", "code": "foodstands"],
      ["name" : "French", "code": "french"],
      ["name" : "French Southwest", "code": "sud_ouest"],
      ["name" : "Galician", "code": "galician"],
      ["name" : "Gastropubs", "code": "gastropubs"],
      ["name" : "Georgian", "code": "georgian"],
      ["name" : "German", "code": "german"],
      ["name" : "Giblets", "code": "giblets"],
      ["name" : "Gluten-Free", "code": "gluten_free"],
      ["name" : "Greek", "code": "greek"],
      ["name" : "Halal", "code": "halal"],
      ["name" : "Hawaiian", "code": "hawaiian"],
      ["name" : "Heuriger", "code": "heuriger"],
      ["name" : "Himalayan/Nepalese", "code": "himalayan"],
      ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
      ["name" : "Hot Dogs", "code": "hotdog"],
      ["name" : "Hot Pot", "code": "hotpot"],
      ["name" : "Hungarian", "code": "hungarian"],
      ["name" : "Iberian", "code": "iberian"],
      ["name" : "Indian", "code": "indpak"],
      ["name" : "Indonesian", "code": "indonesian"],
      ["name" : "International", "code": "international"],
      ["name" : "Irish", "code": "irish"],
      ["name" : "Island Pub", "code": "island_pub"],
      ["name" : "Israeli", "code": "israeli"],
      ["name" : "Italian", "code": "italian"],
      ["name" : "Japanese", "code": "japanese"],
      ["name" : "Jewish", "code": "jewish"],
      ["name" : "Kebab", "code": "kebab"],
      ["name" : "Korean", "code": "korean"],
      ["name" : "Kosher", "code": "kosher"],
      ["name" : "Kurdish", "code": "kurdish"],
      ["name" : "Laos", "code": "laos"],
      ["name" : "Laotian", "code": "laotian"],
      ["name" : "Latin American", "code": "latin"],
      ["name" : "Live/Raw Food", "code": "raw_food"],
      ["name" : "Lyonnais", "code": "lyonnais"],
      ["name" : "Malaysian", "code": "malaysian"],
      ["name" : "Meatballs", "code": "meatballs"],
      ["name" : "Mediterranean", "code": "mediterranean"],
      ["name" : "Mexican", "code": "mexican"],
      ["name" : "Middle Eastern", "code": "mideastern"],
      ["name" : "Milk Bars", "code": "milkbars"],
      ["name" : "Modern Australian", "code": "modern_australian"],
      ["name" : "Modern European", "code": "modern_european"],
      ["name" : "Mongolian", "code": "mongolian"],
      ["name" : "Moroccan", "code": "moroccan"],
      ["name" : "New Zealand", "code": "newzealand"],
      ["name" : "Night Food", "code": "nightfood"],
      ["name" : "Norcinerie", "code": "norcinerie"],
      ["name" : "Open Sandwiches", "code": "opensandwiches"],
      ["name" : "Oriental", "code": "oriental"],
      ["name" : "Pakistani", "code": "pakistani"],
      ["name" : "Parent Cafes", "code": "eltern_cafes"],
      ["name" : "Parma", "code": "parma"],
      ["name" : "Persian/Iranian", "code": "persian"],
      ["name" : "Peruvian", "code": "peruvian"],
      ["name" : "Pita", "code": "pita"],
      ["name" : "Pizza", "code": "pizza"],
      ["name" : "Polish", "code": "polish"],
      ["name" : "Portuguese", "code": "portuguese"],
      ["name" : "Potatoes", "code": "potatoes"],
      ["name" : "Poutineries", "code": "poutineries"],
      ["name" : "Pub Food", "code": "pubfood"],
      ["name" : "Rice", "code": "riceshop"],
      ["name" : "Romanian", "code": "romanian"],
      ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
      ["name" : "Rumanian", "code": "rumanian"],
      ["name" : "Russian", "code": "russian"],
      ["name" : "Salad", "code": "salad"],
      ["name" : "Sandwiches", "code": "sandwiches"],
      ["name" : "Scandinavian", "code": "scandinavian"],
      ["name" : "Scottish", "code": "scottish"],
      ["name" : "Seafood", "code": "seafood"],
      ["name" : "Serbo Croatian", "code": "serbocroatian"],
      ["name" : "Signature Cuisine", "code": "signature_cuisine"],
      ["name" : "Singaporean", "code": "singaporean"],
      ["name" : "Slovakian", "code": "slovakian"],
      ["name" : "Soul Food", "code": "soulfood"],
      ["name" : "Soup", "code": "soup"],
      ["name" : "Southern", "code": "southern"],
      ["name" : "Spanish", "code": "spanish"],
      ["name" : "Steakhouses", "code": "steak"],
      ["name" : "Sushi Bars", "code": "sushi"],
      ["name" : "Swabian", "code": "swabian"],
      ["name" : "Swedish", "code": "swedish"],
      ["name" : "Swiss Food", "code": "swissfood"],
      ["name" : "Tabernas", "code": "tabernas"],
      ["name" : "Taiwanese", "code": "taiwanese"],
      ["name" : "Tapas Bars", "code": "tapas"],
      ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
      ["name" : "Tex-Mex", "code": "tex-mex"],
      ["name" : "Thai", "code": "thai"],
      ["name" : "Traditional Norwegian", "code": "norwegian"],
      ["name" : "Traditional Swedish", "code": "traditional_swedish"],
      ["name" : "Trattorie", "code": "trattorie"],
      ["name" : "Turkish", "code": "turkish"],
      ["name" : "Ukrainian", "code": "ukrainian"],
      ["name" : "Uzbek", "code": "uzbek"],
      ["name" : "Vegan", "code": "vegan"],
      ["name" : "Vegetarian", "code": "vegetarian"],
      ["name" : "Venison", "code": "venison"],
      ["name" : "Vietnamese", "code": "vietnamese"],
      ["name" : "Wok", "code": "wok"],
      ["name" : "Wraps", "code": "wraps"],
      ["name" : "Yugoslav", "code": "yugoslav"]]
  }
  
}
