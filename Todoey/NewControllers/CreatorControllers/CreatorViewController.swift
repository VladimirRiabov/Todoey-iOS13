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
    var itemSubcategory = "note"
    
    var creatorMode = ""
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(creatorMode)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextField.text = itemTitle
        descriptionTextField.text = itemDescription
        datePicker.date = itemDateToBeDoneSort ?? Date()
        if itemSubcategory == "note" {
            noteEventSegmentedControl.selectedSegmentIndex = 0
            noteEventIndexSegmentedControl = 0
            datePicker.isEnabled = false
        } else {
            noteEventSegmentedControl.selectedSegmentIndex = 1
            noteEventIndexSegmentedControl = 1
            datePicker.isEnabled = false
        }
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
                    if creatorMode == "add" {
                        item = Item()
                    }

                    
                    dateFormatters()
                    item.dateOfItemCreation = Date()
                    item.dateOfCreationString = dateOfCreationStr
                    
                    item.title = titleTextField.text!
                    item.descriptionLable = descriptionTextField.text!
                    
                    
                    if noteEventIndexSegmentedControl == 0 {
                        subcategoryItemOne = "note"
                        item.subcutegoryItem = subcategoryItemOne
                        item.dateToBeDoneSort = nil
                        item.dateToBeDone = ""
                        item.timeOfADay = ""
                        item.statusItem = ""
                    }
                    if noteEventIndexSegmentedControl == 1 {
                        dateFormatters()
                        item.timeOfADay = timeOfADay
                        item.dateToBeDone = dateToBeDone
                        subcategoryItemOne = "event"
                        item.subcutegoryItem = subcategoryItemOne
                        item.dateToBeDoneSort = datePicker.date
                        if datePicker.date < startOfDay {
                            item.orCalendarOrTodo = "calendar"
                        }
                    }
                    
                    item.statusItem = ""
                    item.subcutegoryItem = subcategoryItemOne
                    
                    if creatorMode == "add" {
                        GlobalKonstantSingleton.allItemsCategory?.items.append(item)
                        currentCategory.items.append(item)
                    }
                }
            } catch {
                print("Error saving")
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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
