//
//  ToDoCell.swift
//  Todoey
//
//  Created by Владимир Рябов on 10.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

enum CellState {
  case expanded
  case collapsed
}

class ToDoCell: UITableViewCell {
  @IBOutlet weak var titleLabel:UILabel!
  
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.numberOfLines = 1
        }
      }
    
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

