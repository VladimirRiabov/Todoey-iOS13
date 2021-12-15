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

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ffCalendar: FSCalendar!
    
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var dates = Set<String>()
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self

        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "Reusable cell")
        tableView.rowHeight = 80.0
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
     loadItems()
        tableView.reloadData()
    }
    

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
             
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateFormat = "yyyy-MM-dd"
        
           let dateCalendarSelectStr =  dateFormatter.string(from: date)
        
        todoItems = realm.objects(Item.self).filter("dateToBeDone CONTAINS[cd] %@", dateCalendarSelectStr).sorted(byKeyPath: "timeOfADaySort", ascending: true)
        tableView.reloadData()
        
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
     
        todoItems = realm.objects(Item.self).filter("dateToBeDone CONTAINS[cd] %@", GlobalKonstantSingleton.currentDateStr!)
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateFormat = "yyyy-MM-dd"

        for dateStr in dates {
            if(dateFormatter.string(from: date) == dateStr)
            {
                return 1
            }
        }
        return 0
    }
   
   
    @objc func loadList(notification: NSNotification){
        //see up
        self.tableView.reloadData()
    }
    //MARK: - Loading ToDo func
    func loadItems() {
//        let sortProperties = [SortDescriptor(keyPath: "dateToBeDoneSort", ascending: true), SortDescriptor(keyPath: "timeOfADaySort", ascending: true)]
//        allShowsByDate = Realm().objects(MyObjectType).sorted(sortProperties)
        
        todoItems = realm.objects(Item.self).sorted(by: [SortDescriptor(keyPath: "dateToBeDone", ascending: true), SortDescriptor(keyPath: "timeOfADay", ascending: true)])
            
        }
//            .filter("dateToBeDone CONTAINS[cd] %@", GlobalKonstantSingleton.currentDateStr!)
        
        
//    }
    
    
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
            cell.needToBeDoneLabel.text = item.dateToBeDone
            cell.timeOfADatLabel.text = item.timeOfADay
            dates.insert(item.dateToBeDone)
            print(item.timeOfADaySort)
            

            cell.accessoryType = item.done == true ? .checkmark : .none
            print("arbeitet")
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
           return Date()
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
