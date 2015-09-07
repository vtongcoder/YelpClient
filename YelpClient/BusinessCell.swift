//
//  BusinessCell.swift
//  YelpClient
//
//  Created by Dan Tong on 9/3/15.
//  Copyright © 2015 DanTong. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var business: Business! {
        didSet{
            nameLabel.text = business.name
            categoriesLabel.text = business.categories
            addressLabel.text      = business.address
            distanceLabel.text      = business.distance
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            thumbImage.setImageWithURL(business.imageURL)
            ratingImage.setImageWithURL(business.ratingImageURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImage.layer.cornerRadius = 3
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
