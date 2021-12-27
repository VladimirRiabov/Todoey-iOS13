//
//  CreatorViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 27.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit


class CreatorViewController: UIViewController {
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var noteEventSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    var selectedCategory : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
    }
    

}
