//
//  NewToDoViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 10.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class NewToDoViewController: SwipeViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    //MARK: - OUTLETS TODO VIEW
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var labelOfCategory: UILabel!
    @IBOutlet weak var subcategoryOutlet: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    
    //MARK: - OUTLETS ADD ITEM VIEW
    
    @IBOutlet var addViewOutlet: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var titleTextFieldAdd: UITextField!
    @IBOutlet weak var descriptionTextFieldAdd: UITextField!
    @IBOutlet weak var datePickerAdd: UIDatePicker!
    @IBOutlet weak var segmentedControllerAddOutlet: UISegmentedControl!
    
    //MARK: - OUTLETS UPDATE ITEM
    
    @IBOutlet var viewUpdateOutlet: UIView!
    @IBOutlet weak var editNoteEventLabel: UILabel!
    @IBOutlet weak var titleUpdateTextField: UITextField!
    @IBOutlet weak var descriptionUpdateTextField: UITextField!
    @IBOutlet weak var noteEventSCUpdate: UISegmentedControl!
    @IBOutlet weak var datePickerUpdate: UIDatePicker!
    
    
    
    
    //MARK: - VARS
    var pickerDataArray: Array = Array<String>()
    var pickerDataSet: Set = Set<String>()
    var sortingVar = "dateOfItemCreation"
    var subcutegoryItemVar = "note"
    var subcategoryItemOne = "note"
    var todoItems: Results<Item>?
    var abcde: String?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    var currentCategoryTransition = GlobalKonstantSingleton()
    var subcategorySegmentedControlIndex = 0
    var swipeActions: UISwipeActionsConfiguration?
    
    var screenEffect: UIVisualEffect?
    var indexSegmentedControlAdd = 0
    var timeOfADay = ""
    var dateToBeDone = ""
    
    var indexSegmentedControlUpdate = 0
    var indexPathTrailingRow = 0
    
    let startOfDay: Date = Calendar.current.startOfDay(for: Date())
    let components = DateComponents(hour: 23, minute: 59, second: 59)
    
    var itemTitle = ""
    var itemDescription = ""
    var itemDateToBeDoneSort: Date?
    var itemSubcategory = ""
    
    var itemToCreator: Item?
    
    
    
    //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalKonstantSingleton.selectedClassCategory = selectedCategory
        
        labelOfCategory.text = selectedCategory?.name
        
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.alpha = 0
        
        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "Reusable cell")
        
        tableView.rowHeight = 80.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        
        
        
    }
    
    @objc func loadList(notification: NSNotification){
        //see up
        picker.delegate = self
        self.tableView.reloadData()
        loadItems()
        
    }
    //MARK: - Loading ToDo func
    func loadItems() {
        
        todoItems = selectedCategory?.items.filter("subcutegoryItem CONTAINS[cd] %@", subcutegoryItemVar).filter("orCalendarOrTodo CONTAINS[cd] %@", "todo").sorted(byKeyPath: sortingVar, ascending: true)
        print(todoItems)
        
        pickerDataArray = selectedCategory?.items.filter("subcutegoryItem CONTAINS[cd] %@", "event").filter("orCalendarOrTodo CONTAINS[cd] %@", "todo").value(forKey: "dateToBeDone") as! [String]
        pickerDataSet = Set(pickerDataArray)
        //        picker.delegate = self
        //        tableView.reloadData()
        
    }
    //MARK: - WEEL FILTER
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSet.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSet.sorted(by: <)[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadItems()
        
        abcde = pickerDataSet.sorted(by: <)[row]
        
        if abcde != nil {
            todoItems = todoItems?.filter("dateToBeDone CONTAINS[cd] %@", abcde).filter("orCalendarOrTodo CONTAINS[cd] %@", "todo")
        }
        
        self.tableView.reloadData()
        
    }
    
    
    
    //MARK: - SEGMENTED CONTROLLER NOTE/EVENT
    @IBAction func subcategorySegmentedControlIndexChanged(_ sender: UISegmentedControl) {
        switch subcategoryOutlet.selectedSegmentIndex
        {
        case 0:
            subcategorySegmentedControlIndex = 0
            picker.alpha = 0
            subcategoryLabel.text = "Notes"
            subcutegoryItemVar = "note"
            sortingVar = "dateOfItemCreation"
            loadItems()
            tableView.reloadData()
            
        case 1:
            subcategorySegmentedControlIndex = 1
            picker.alpha = 1
            subcategoryLabel.text = "Events"
            subcutegoryItemVar = "event"
            sortingVar = "dateToBeDoneSort"
            loadItems()
            tableView.reloadData()
            
        default:
            break
        }
        print(subcategoryOutlet.selectedSegmentIndex)
    }
    
    
    //MARK: - DataSourceMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reusable cell", for: indexPath) as! ToDoTableViewCell
        if let item = todoItems?[indexPath.row] {
            
            let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)
            if item.dateToBeDoneSort != nil {
                if Calendar.current.isDateInToday(item.dateToBeDoneSort!) {
                    do {
                        try self.realm.write {
                            item.orCalendarOrTodo = "todo"
                        }
                    } catch {
                        print("Error while encoding \(error)")
                    }
                } else if item.dateToBeDoneSort! > Date() {
                    do {
                        try self.realm.write {
                            item.orCalendarOrTodo = "todo"
                            
                        }
                    } catch {
                        print("Error while encoding \(error)")
                    }
                } else if item.dateToBeDoneSort! < Date() {
                    do {
                        try self.realm.write {
                            item.orCalendarOrTodo = "calendar"
                            
                        }
                    } catch {
                        print("Error while encoding \(error)")
                    }
                }
            }
            
            //                print(Calendar.current.startOfDay(for: item.dateToBeDoneSort!))
            //                let startOfDay: Date = Calendar.current.startOfDay(for: Date())
            //                let components = DateComponents(hour: 23, minute: 59, second: 59)
            //                let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)
            //                print(endOfDay)
            
            
            
            if item.statusItem == "Not done" {
                cell.colorStatusView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            } else if item.statusItem == "Done" {
                cell.colorStatusView.backgroundColor = #colorLiteral(red: 0.7858344316, green: 1, blue: 0.6146927476, alpha: 1)
            } else {
                cell.colorStatusView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            }
            
            cell.status.text = item.orCalendarOrTodo
            cell.statusLabel.text = item.statusItem
            cell.titleLable.text = item.title
            cell.subtitleLabel.text = item.descriptionLable
            cell.needToBeDoneLabel.text = item.dateToBeDone
            cell.timeOfADatLabel.text = item.timeOfADay
            cell.dataOfCreation.text = item.dateOfCreationString
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: - SWIPE CELL
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let doneAction = UIContextualAction(style: .normal, title: "Done") { (contextualAction, view, boolValue) in
//
//            if let item = self.todoItems?[indexPath.row] {
//
//                do {
//                    try self.realm.write {
//                        item.statusItem = "Done"
//                    }
//                } catch {
//                    print("Error while encoding \(error)")
//                }
//            }
//
//
//            boolValue(true) // pass true if you want the handler to allow the action
//            print("Leading Action style .normal")
//            tableView.reloadData()
//        }
//        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//
//        let notDoneAction = UIContextualAction(style: .normal, title: "Not done") { (contextualAction, view, boolValue) in
//
//            if let item = self.todoItems?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        item.statusItem = "Not done"
//                    }
//                } catch {
//                    print("Error while encoding \(error)")
//                }
//            }
//
//
//            boolValue(true) // pass true if you want the handler to allow the action
//
//            tableView.reloadData()
//        }
//
//        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//        notDoneAction.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
//
//        if subcategorySegmentedControlIndex == 1 {
//            swipeActions = UISwipeActionsConfiguration(actions: [doneAction, notDoneAction])
//        } else {
//            swipeActions = UISwipeActionsConfiguration(actions: [])
//        }
//        return swipeActions
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handelr) in
//            print("delete")
//            if let item = self.todoItems?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(item)
//                    }
//                } catch {
//                    print("Error while encoding \(error)")
//                }
//            }
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//            handelr(true)
//            self.loadItems()
//            self.abcde = self.pickerDataSet.sorted(by: <).last
//            self.picker.delegate = self
//            self.tableView.reloadData()
//        }
//        let editorAction = UIContextualAction(style: .normal, title: "Edit") { action, view, handler in
//
//            if let item = self.todoItems?[indexPath.row] {
//                self.itemToCreator = item
//                self.itemTitle = item.title
//                self.itemDescription = item.descriptionLable
//                self.itemDateToBeDoneSort = item.dateToBeDoneSort ?? Date()
//                self.itemSubcategory = item.subcutegoryItem
//                handler (true)
//                self.performSegue(withIdentifier: "toItemCreatorUpdate", sender: self)
//                //                    self.performSegue(withIdentifier: "toItemCreatorUpdate", sender: self)
//                print(self.itemTitle, self.itemDescription)
//            }
//        }
//        editorAction.backgroundColor = UIColor.systemBlue
//        let swipeaction = UISwipeActionsConfiguration(actions: [deleteAction, editorAction])
//        return swipeaction
//    }
//
//    //MARK: - NEW TODO ADDVIEW ITEM BLOCK
//    @IBAction func toAddViewButtonPressed(_ sender: UIButton) {
//        performSegue(withIdentifier: "toItemCreator", sender: self)
//    }
//
//}
//
//
//extension NewToDoViewController {
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toItemCreator" {
//            let destinationVC = segue.destination as! CreatorViewController
//
//            destinationVC.selectedCategory = selectedCategory
//            destinationVC.itemTitle = ""
//            destinationVC.itemDescription = ""
//            destinationVC.itemDateToBeDoneSort = Date()
//            destinationVC.itemSubcategory = "note"
//            destinationVC.creatorMode = "add"
//
//        } else if segue.identifier == "toItemCreatorUpdate" {
//            let destinationVC = segue.destination as! CreatorViewController
//            destinationVC.selectedCategory = selectedCategory
//            destinationVC.itemTitle = itemTitle
//            destinationVC.itemDescription = itemDescription
//            destinationVC.itemDateToBeDoneSort = itemDateToBeDoneSort ?? Date()
//            destinationVC.itemSubcategory = itemSubcategory
//            destinationVC.item = itemToCreator
//            destinationVC.creatorMode = "update"
//
//            print("sequae edit is performed")
//
//        }
//    }
//
}




