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
    var timeOfADay = "--:--"
    var dateToBeDone = ""
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    let realm = try! Realm()
    var categories: Results<Category>?
    

    @IBOutlet weak var titileOfTaskTextField: UITextField!
    @IBOutlet weak var descriptionTaskTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

    
    
    @IBAction func timeActionSent(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()

            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateFormat = "HH:mm"

            timeOfADay = dateFormatter.string(from: timePicker.date)
          print(timeOfADay)
    }
    
    @IBAction func datePickerPressed(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
             
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateToBeDone =  dateFormatter.string(from: datePicker.date)
        print(dateToBeDone)
    }
    
    
    @IBAction func AddNewTask(_ sender: UIButton) {
        if let currentCategory = GlobalKonstantSingleton.selectedClassCategory {
                       do {
                           try self.realm.write {
                               let newItem = Item()
                               newItem.title = titileOfTaskTextField.text!
                               newItem.descriptionLable = descriptionTaskTextField.text!

                               newItem.dateOfItemCreation = Date()
                               
                               newItem.timeOfADaySort = timePicker.date
                               newItem.timeOfADay = timeOfADay
                               
                               newItem.dateToBeDoneSort = datePicker.date
                               newItem.dateToBeDone = dateToBeDone
                               
                               
                               
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
    @IBAction func addCategoryButton(_ sender: UIButton) {
        
        
//            if let currentCategory = self.selectedCategory {
//                do {
//                    try self.realm.write {
//                        let newItem = Item()
//                        newItem.title = textField.text!
//                        newItem.dateCreated = Date()
//                        currentCategory.items.append(newItem)
//                        self.currentClassCategory.selectedClassCategory = currentCategory
//                    }
//                } catch {
//                    print("Error saving")
//                }
//            }
//            self.tableView.reloadData()
//        }
//        alert.addAction(action)
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Create new item"
//            textField = alertTextField
//        }
//
//        present(alert, animated: true, completion: nil)
        

    
    
    
    
    
    
    
    
//            let newCategory = Category()
//            let date = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "YY/MM/dd"
//            dateFormatter.string(from: date)
//            newCategory.dateOfCreation = Date()
//            newCategory.dateOfCreationString =  dateFormatter.string(from: date)
//
//            self.save(category: newCategory)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//        self.dismiss(animated: true, completion: nil)
////            dismissController()
////            NewCategoryViewController.tableView.reloadData()
       
    }
}
