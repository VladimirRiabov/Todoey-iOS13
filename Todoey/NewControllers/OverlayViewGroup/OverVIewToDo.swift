//
//  OverVIewToDo.swift
//  Todoey
//
//  Created by Владимир Рябов on 11.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift



class OverVIewToDo: UIViewController {
    
    let currentCategoryTransition = GlobalKonstantSingleton()
    var timeOfADay = ""
    var dateToBeDone = ""
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var userForgotToChooseAdate: Date?
    var subcutegoryItemVar : String = "note"
    var indexSegmentedControl = 0
    
    let realm = try! Realm()
    var categories: Results<Category>?
    

    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    @IBOutlet weak var titileOfTaskTextField: UITextField!
    @IBOutlet weak var descriptionTaskTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isEnabled = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        datePicker.minimumDate = Date()
//        slideIdicator.roundCorners(.allCorners, radius: 10)
        
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
//        tableView.reloadData()
    }
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error while encoding \(error)")
        }
    }
    
    
    
    
    @IBAction func segmentedControlIndexChanged(_ sender: UISegmentedControl) {
        switch segmentedControlOutlet.selectedSegmentIndex
            {
            case 0:
            datePicker.isEnabled = false
            var subcutegoryItemVar : String = "note"
//                .isUserInteractionEnabled = false
            case 1:
            datePicker.isEnabled = true
            var subcutegoryItemVar : String = "event"
            userForgotToChooseAdate = Date()
            default:
                break
            }
        indexSegmentedControl = segmentedControlOutlet.selectedSegmentIndex
        print(indexSegmentedControl)
        
    }
    
    

    @IBAction func datePickerPressed(_ sender: UIDatePicker) {
       
    }
    
    
    @IBAction func AddNewTask(_ sender: UIButton) {
        if let currentCategory = GlobalKonstantSingleton.selectedClassCategory {
                       do {
                           try self.realm.write {
                               let newItem = Item()
                               dateFormatters()
                               
                               newItem.title = titileOfTaskTextField.text!
                               newItem.descriptionLable = descriptionTaskTextField.text!

                               newItem.dateOfItemCreation = Date()
                               if indexSegmentedControl == 1 {
                                   dateFormatters()
                                   newItem.timeOfADay = timeOfADay
                                   newItem.dateToBeDone = dateToBeDone
                                   subcutegoryItemVar = "event"
                               }
                               newItem.dateToBeDoneSort = datePicker.date
                               
                              
                             
                               GlobalKonstantSingleton.allItemsCategory?.items.append(newItem)
                               currentCategory.items.append(newItem)
                           }
                       } catch {
                           print("Error saving")
                       }
                   }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
       
    }
    func dateFormatters() {
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateFormat = "yyyy-MM-dd"
        dateToBeDone =  dateFormatter.string(from: datePicker.date)
        let dateFormatter2 = DateFormatter()
            dateFormatter2.dateStyle = DateFormatter.Style.short
            dateFormatter2.timeStyle = DateFormatter.Style.short
            dateFormatter2.dateFormat = "HH:mm"
            timeOfADay = dateFormatter2.string(from: datePicker.date)
    }
}
