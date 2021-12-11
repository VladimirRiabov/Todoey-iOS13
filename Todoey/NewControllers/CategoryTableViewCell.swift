//
//  CategoryTableViewCell.swift
//  Todoey
//
//  Created by Владимир Рябов on 10.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var dateOfCreationLAbel: UILabel!
    @IBOutlet weak var CountOfItems: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
