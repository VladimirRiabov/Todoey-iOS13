//
//  OverlayView.swift
//  Todoey
//
//  Created by Владимир Рябов on 11.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class OverlayView: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    @IBOutlet weak var slideIdicator: UIView!

    @IBOutlet weak var titleCategoryTextField: UITextField!
    

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)

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
//        tableView.reloadData()
    }
    
    
    
    @IBAction func addCategoryButton(_ sender: UIButton) {
        
            let newCategory = Category()
        newCategory.name = titleCategoryTextField.text ?? ""
        
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "dd/MM/YY"
            dateFormatter.string(from: date)
            newCategory.dateOfCreation = Date()
            newCategory.dateOfCreationString =  dateFormatter.string(from: date)
            
            self.save(category: newCategory)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
//            dismissController()
//            NewCategoryViewController.tableView.reloadData()
       
    }
}

