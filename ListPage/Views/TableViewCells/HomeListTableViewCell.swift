//
//  HomeListTableViewCell.swift
//  ListPage
//
//  Created by Athul Raj on 10/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit

class HomeListTableViewCell: UITableViewCell {

    @IBOutlet var propertyTitle: UILabel!
    @IBOutlet var propertySubTitle: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var furnitLabel: UILabel!
    @IBOutlet var sqFeetLabel: UILabel!
    @IBOutlet var bathroomLabel: UILabel!
    @IBOutlet var propertyImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
