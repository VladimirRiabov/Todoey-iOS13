//
//  TrashViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 13.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar

class TrashViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self

        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "Reusable cell")
        tableView.rowHeight = 80.0
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
     loadItems()
        print(todoItems)
    }
    
    @objc func loadList(notification: NSNotification){
        //see up
        self.tableView.reloadData()
    }
    //MARK: - Loading ToDo func
    func loadItems() {
        todoItems = realm.objects(Item.self)
        
    }
    
    
    //MARK: - IBActions
    
    
    
    //MARK: - DataSourceMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reusable cell", for: indexPath) as! ToDoTableViewCell
        if let item = todoItems?[indexPath.row] {
            cell.titleLable.text = item.title
            cell.subtitleLabel.text = item.descriptionLable
            cell.needToBeDoneLabel.text = item.needToBeDoneLable
            cell.timeOfADatLabel.text = item.timeOfADay

            cell.accessoryType = item.done == true ? .checkmark : .none
            print("arbeitet")
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handelr) in
//            print("delete")
////            if let item = self.todoItems?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(item)
//                    }
//                } catch {
//                    print("Error while encoding \(error)")
//                }
//            }
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//
//            handelr(true)
//        }
//        let swipeaction = UISwipeActionsConfiguration(actions: [action])
//        return swipeaction
//    }
    
}
