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
    
    var subcategoryItemOne = "note"
    var noteEventIndexSegmentedControl = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isEnabled = false
        
        
    }
  
        
    @IBAction func noteEventIndexChanged(_ sender: UISegmentedControl) {
        switch noteEventSegmentedControl.selectedSegmentIndex
            {
            case 0:
            datePicker.isEnabled = false
            subcategoryItemOne = "note"
            case 1:
            datePicker.isEnabled = true
            subcategoryItemOne = "event"
            default:
                break
            }
        noteEventIndexSegmentedControl = noteEventSegmentedControl.selectedSegmentIndex
        print(noteEventIndexSegmentedControl)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
    }
    

}
