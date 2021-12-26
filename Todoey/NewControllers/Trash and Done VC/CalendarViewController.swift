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
    
    var DATESARRAY: Array = Array<String>()
    var DATESSET: Set = Set<String>()
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
        ffCalendar.delegate = self
        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "Reusable cell")
        tableView.rowHeight = 80.0
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
     loadItems()
        tableView.reloadData()
        loadDatesCalendar()
        dates = DATESSET
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
                print("suuuuuuuuukiiiiiiiiiiiiiiiiiiiiiiiiiii")
                print(dates)
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
        
        todoItems = realm.objects(Item.self).filter("subcutegoryItem CONTAINS[cd] %@", "event").sorted(byKeyPath: "dateToBeDoneSort", ascending: true)
            
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
            
            
            
            if item.statusItem == "" {
                do {
                    try self.realm.write {
                        item.statusItem = "Unknown"
                        dates.insert(item.dateToBeDone)
                    }
                } catch {
                    print("Error while encoding \(error)")
                }
                
            }
            
            
//                if item.dateToBeDoneSort != nil {
//                    if item.dateToBeDoneSort! < Date() {
//
//                        do {
//                            try self.realm.write {
//                                item.statusItem = "Unknown"
//
//                            }
//                        } catch {
//                            print("Error while encoding \(error)")
//                            }
//                        }
//                    }
            
            dates.insert(item.dateToBeDone)
            print(item.dateToBeDone)
            if item.statusItem == "Not done" {
                cell.colorStatusView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            } else if item.statusItem == "Done" {
                cell.colorStatusView.backgroundColor = #colorLiteral(red: 0.7858344316, green: 1, blue: 0.6146927476, alpha: 1)
            } else {
                cell.colorStatusView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            }
//            print(item.statusItem )
            cell.status.text = item.orCalendarOrTodo
            cell.statusLabel.text = item.statusItem
            cell.titleLable.text = item.title
            cell.subtitleLabel.text = item.descriptionLable
            cell.needToBeDoneLabel.text = item.dateToBeDone
            cell.timeOfADatLabel.text = item.timeOfADay
            cell.dataOfCreation.text = item.dateOfCreationString
            dates.insert(item.dateToBeDone)
            
            

            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    func loadDatesCalendar() {
        
        
        
        DATESARRAY = todoItems?.filter("subcutegoryItem CONTAINS[cd] %@", "event").value(forKey: "dateToBeDone") as! [String]
        DATESSET = Set(DATESARRAY)
        print(DATESSET)
        
//        picker.delegate = self
//        tableView.reloadData()

    }
    

}
