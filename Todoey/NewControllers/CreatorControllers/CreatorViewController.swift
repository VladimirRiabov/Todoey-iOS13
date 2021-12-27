//
//  CreatorViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 27.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


class CreatorViewController: UIViewController {
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var noteEventSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory : Category?
    
    var dateOfCreationStr = ""
    var timeOfADay = ""
    var dateToBeDone = ""
    var subcategoryItemOne = "note"
    
    var noteEventIndexSegmentedControl = 0
    
    let startOfDay: Date = Calendar.current.startOfDay(for: Date())
    let components = DateComponents(hour: 23, minute: 59, second: 59)
    
    var itemTitle = ""
    var itemDescription = ""
    var itemDateToBeDoneSort: Date?
    var itemSubcategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isEnabled = false
        
        
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        print(itemTitle)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        titleTextField.text = itemTitle
        descriptionTextField.text = itemDescription
        datePicker.date = itemDateToBeDoneSort ?? Date()
        
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let currentCategory = selectedCategory {
            do {
                try self.realm.write {
                    let newItem = Item()
                    
                    dateFormatters()
                    newItem.dateOfItemCreation = Date()
                    newItem.dateOfCreationString = dateOfCreationStr
                    
                    newItem.title = titleTextField.text!
                    newItem.descriptionLable = descriptionTextField.text!
                    
                    if noteEventIndexSegmentedControl == 1 {
                        dateFormatters()
                        newItem.timeOfADay = timeOfADay
                        newItem.dateToBeDone = dateToBeDone
                        subcategoryItemOne = "event"
                        newItem.subcutegoryItem = subcategoryItemOne
                        newItem.dateToBeDoneSort = datePicker.date
                        print("[hui pizda")
                        if datePicker.date < startOfDay {
                            newItem.orCalendarOrTodo = "calendar"
                        }
                    }
                    newItem.statusItem = ""
                    newItem.subcutegoryItem = subcategoryItemOne
                    
                    GlobalKonstantSingleton.allItemsCategory?.items.append(newItem)
                    currentCategory.items.append(newItem)
                    
                }
            } catch {
                print("Error saving")
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}

//MARK: - DataFormatters
extension CreatorViewController {
    func dateFormatters() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateToBeDone =  dateFormatter.string(from: datePicker.date)
        dateOfCreationStr = dateFormatter.string(from: Date())
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = DateFormatter.Style.short
        dateFormatter2.timeStyle = DateFormatter.Style.short
        dateFormatter2.dateFormat = "HH:mm"
        timeOfADay = dateFormatter2.string(from: datePicker.date)
    }
}
