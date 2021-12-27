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

class NewToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
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
        
        addViewOutlet.layer.cornerRadius = addViewOutlet.frame.height / 15
        if let effect = blurEffect.effect {
            screenEffect = effect
        } else {
            screenEffect = UIVisualEffect()
        }
//        blurEffect.effect = nil
        
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
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (contextualAction, view, boolValue) in
            
            if let item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        item.statusItem = "Done"
                    }
                } catch {
                    print("Error while encoding \(error)")
                }
            }
            
            
            boolValue(true) // pass true if you want the handler to allow the action
            print("Leading Action style .normal")
            tableView.reloadData()
        }
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        let notDoneAction = UIContextualAction(style: .normal, title: "Not done") { (contextualAction, view, boolValue) in
            
            if let item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        item.statusItem = "Not done"
                    }
                } catch {
                    print("Error while encoding \(error)")
                }
            }
            
            
            boolValue(true) // pass true if you want the handler to allow the action
           
            tableView.reloadData()
        }
        
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        notDoneAction.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        if subcategorySegmentedControlIndex == 1 {
            swipeActions = UISwipeActionsConfiguration(actions: [doneAction, notDoneAction])
        } else {
            swipeActions = UISwipeActionsConfiguration(actions: [])
        }
        

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handelr) in
            print("delete")
            if let item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                } catch {
                    print("Error while encoding \(error)")
                }
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            handelr(true)
            self.loadItems()
            self.abcde = self.pickerDataSet.sorted(by: <).last
            self.picker.delegate = self
            self.tableView.reloadData()
        }
        let editorAction = UIContextualAction(style: .normal, title: "Edit") { action, view, handler in
            
            self.noteEventSCUpdate.selectedSegmentIndex = 0
            
            self.datePickerUpdate.isEnabled = false
            //            titleTextFieldAdd.text = item.
            //            descriptionTextFieldAdd.text = ""
            self.view.addSubview(self.viewUpdateOutlet)
            self.viewUpdateOutlet.center.x = self.view.center.x
            self.viewUpdateOutlet.center.y = self.view.center.y - (self.view.frame.height / 4.0)
            self.viewUpdateOutlet.alpha = 0
            self.viewUpdateOutlet.transform = CGAffineTransform(translationX: 0.2, y: 0.2)
            UIView.animate(withDuration: 0.4) {
                self.viewUpdateOutlet.alpha = 1
                self.viewUpdateOutlet.transform = CGAffineTransform.identity
                self.blurEffect.alpha = 1
                self.blurEffect.effect = self.screenEffect
                
                self.indexPathTrailingRow = indexPath.row
                
                if let item = self.todoItems?[indexPath.row] {
                    self.titleUpdateTextField.text = item.title
                    self.descriptionUpdateTextField.text = item.descriptionLable
                    self.datePickerUpdate.date = item.dateToBeDoneSort ?? Date()
                    if item.subcutegoryItem == "note" {
                        self.indexSegmentedControlUpdate = 0
                        self.noteEventSCUpdate.selectedSegmentIndex = 0
                    } else {
                        self.indexSegmentedControlUpdate = 1
                        self.noteEventSCUpdate.selectedSegmentIndex = 1
                        self.datePickerUpdate.isEnabled = true
                    }
//                    do {
//                        try self.realm.write {
////                            item.title = self.titleUpdateTextField.text ?? ""
////                            item.descriptionLable = self.descriptionUpdateTextField.text ?? ""
//
////                            self.realm.delete(item)
//                        }
//                    } catch {
//                        print("Error while encoding \(error)")
//                    }
                }
                
                handler (true)
            }
        }
        editorAction.backgroundColor = UIColor.systemBlue
        let swipeaction = UISwipeActionsConfiguration(actions: [deleteAction, editorAction])
        return swipeaction
    }
    
    //MARK: - NEW TODO ADDVIEW ITEM BLOCK
    //работает
    @IBAction func toAddViewButtonPressed(_ sender: UIButton) {
        segmentedControllerAddOutlet.selectedSegmentIndex = 0
        datePickerAdd.isEnabled = false
        titleTextFieldAdd.text = ""
        descriptionTextFieldAdd.text = ""
        self.view.addSubview(addViewOutlet)
        self.addViewOutlet.center.x = self.view.center.x
        self.addViewOutlet.center.y = self.view.center.y - (self.view.frame.height / 4.0)
        addViewOutlet.alpha = 0
        addViewOutlet.transform = CGAffineTransform(translationX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.4) {
            self.addViewOutlet.alpha = 1
            self.addViewOutlet.transform = CGAffineTransform.identity
            self.blurEffect.alpha = 1
            self.blurEffect.effect = self.screenEffect
        }
    }
    //работает
    
    
    @IBAction func segmentedControllAddIndexChanged(_ sender: UISegmentedControl) {
        
            switch segmentedControllerAddOutlet.selectedSegmentIndex
                {
                case 0:
                datePickerAdd.isEnabled = false
                subcategoryItemOne = "note"
                
                

                case 1:
                datePickerAdd.isEnabled = true
                subcategoryItemOne = "event"
               
               
                
                default:
                    break
                }
            indexSegmentedControlAdd = segmentedControllerAddOutlet.selectedSegmentIndex
            print(indexSegmentedControlAdd)
    }
    
   
    
    @IBAction func datePickerAddPressed(_ sender: UIDatePicker) {
        
    }
    //работает
    @IBAction func addNewItemAddButton(_ sender: UIButton) {
        if let currentCategory = selectedCategory {
                       do {
                           try self.realm.write {
                               let newItem = Item()
                               dateFormatters()
                               
                               newItem.title = titleTextFieldAdd.text!
                               newItem.descriptionLable = descriptionTextFieldAdd.text!

                               newItem.dateOfItemCreation = Date()
                               
                               if indexSegmentedControlAdd == 1 {
                                   dateFormatters()
                                   newItem.timeOfADay = timeOfADay
                                   newItem.dateToBeDone = dateToBeDone
                                   subcutegoryItemVar = "event"
                                   subcategoryItemOne = "event"
                                   newItem.subcutegoryItem = subcategoryItemOne
                                   newItem.dateToBeDoneSort = datePickerAdd.date
                                   print("[hui pizda")
                                   if datePickerAdd.date < startOfDay {
                                       newItem.orCalendarOrTodo = "calendar"
                                       
                                   }
                                   newItem.statusItem = ""
                                   
                               }
                               print("this is index of segmented controll")
                               print(indexSegmentedControlAdd)
                               
                               let dateFormatter = DateFormatter()
                                   dateFormatter.dateStyle = DateFormatter.Style.short
                                   dateFormatter.timeStyle = DateFormatter.Style.short
                                   dateFormatter.dateFormat = "yyyy-MM-dd"
                               newItem.dateOfCreationString = dateFormatter.string(from: Date())
                               
                               newItem.subcutegoryItem = subcategoryItemOne

                               GlobalKonstantSingleton.allItemsCategory?.items.append(newItem)
                               currentCategory.items.append(newItem)
                               
                               indexSegmentedControlAdd = 0
                               subcategoryItemOne = "note"

                           }
                       } catch {
                           print("Error saving")
                       }
                   }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.4) {
            self.addViewOutlet.alpha = 0
        } completion: { status in

            self.blurEffect.alpha = 0
            self.addViewOutlet.alpha = 0
            self.addViewOutlet.removeFromSuperview()
           
        }
        
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
        
        picker.delegate = self
        self.tableView.reloadData()
        loadItems()
        
       
    }
    func dateFormatters() {
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateFormat = "yyyy-MM-dd"
        dateToBeDone =  dateFormatter.string(from: datePickerAdd.date)
        
        let dateFormatter2 = DateFormatter()
            dateFormatter2.dateStyle = DateFormatter.Style.short
            dateFormatter2.timeStyle = DateFormatter.Style.short
            dateFormatter2.dateFormat = "HH:mm"
            timeOfADay = dateFormatter2.string(from: datePickerAdd.date)
    }
    
    
    //работает
    @IBAction func cancelAddViewButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4) {
            self.addViewOutlet.alpha = 0
        } completion: { status in

            self.blurEffect.alpha = 0
            self.addViewOutlet.alpha = 0
            self.addViewOutlet.removeFromSuperview()
           
        }

    }
    //MARK: - UPDATE ITEM BLOCK
    @IBAction func segmentedControllerUpdateIndexChanged(_ sender: UISegmentedControl) {
        switch noteEventSCUpdate.selectedSegmentIndex
            {
            case 0:
            datePickerUpdate.isEnabled = false

            case 1:
            datePickerUpdate.isEnabled = true
            
            default:
                break
            }
        indexSegmentedControlUpdate = noteEventSCUpdate.selectedSegmentIndex
        
    }
    @IBAction func cancelUpdateButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4) {
            self.viewUpdateOutlet.alpha = 0
        } completion: { status in

            self.blurEffect.alpha = 0
            self.viewUpdateOutlet.alpha = 0
            self.viewUpdateOutlet.removeFromSuperview()
           
        }
    }
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        if let item = self.todoItems?[indexPathTrailingRow] {
                    do {
                        try self.realm.write {
                            item.title = self.titleUpdateTextField.text ?? ""
                            item.descriptionLable = self.descriptionUpdateTextField.text ?? ""
                            
                            
                            item.dateOfItemCreation = Date()
                            if indexSegmentedControlUpdate == 1 {
                                dateFormattersUpdate()
                                item.timeOfADay = timeOfADay
                                item.dateToBeDone = dateToBeDone
                                subcutegoryItemVar = "event"
                                item.subcutegoryItem = subcutegoryItemVar
                                item.dateToBeDoneSort = self.datePickerUpdate.date
                                if datePickerUpdate.date < startOfDay {
                                    item.orCalendarOrTodo = "calendar"
                                }
//                                item.statusItem = ""
                            }
                            if indexSegmentedControlUpdate == 0 {
                                subcutegoryItemVar = "note"
                                item.subcutegoryItem = subcutegoryItemVar
                                item.dateToBeDoneSort = nil
                                item.dateToBeDone = ""
                                item.timeOfADay = ""
                                item.statusItem = ""
                            }
                            
                            let dateFormatter = DateFormatter()
                                dateFormatter.dateStyle = DateFormatter.Style.short
                                dateFormatter.timeStyle = DateFormatter.Style.short
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                            item.dateOfCreationString = dateFormatter.string(from: Date())
                            
                            item.subcutegoryItem = subcutegoryItemVar

//                            GlobalKonstantSingleton.allItemsCategory?.items.append(newItem)
//                            currentCategory.items.append(newItem)
                            
                        }
                    } catch {
                        print("Error while encoding \(error)")
                    }
            
            
        }
        
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
        
        loadItems()
        
        
        picker.delegate = self
        tableView.reloadData()
//        self.loadItems()
//        self.abcde = self.pickerDataSet.sorted(by: <).last
//        self.picker.delegate = self
        
        
        UIView.animate(withDuration: 0.4) {
            self.viewUpdateOutlet.alpha = 0
        } completion: { status in

            self.blurEffect.alpha = 0
            self.viewUpdateOutlet.alpha = 0
            self.viewUpdateOutlet.removeFromSuperview()

//        print(todoItems)
        }
        func dateFormattersUpdate() {
            let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.short
                dateFormatter.timeStyle = DateFormatter.Style.short
                dateFormatter.dateFormat = "yyyy-MM-dd"
            dateToBeDone =  dateFormatter.string(from: datePickerUpdate.date)
            
            let dateFormatter2 = DateFormatter()
                dateFormatter2.dateStyle = DateFormatter.Style.short
                dateFormatter2.timeStyle = DateFormatter.Style.short
                dateFormatter2.dateFormat = "HH:mm"
                timeOfADay = dateFormatter2.string(from: datePickerUpdate.date)
        }
        
        
    }
    
    
    
    
    //MARK: - OLD ADD VIEW
    
//    @objc func showMiracle() {
//        let slideVC = OverVIewToDo()
//        slideVC.modalPresentationStyle = .custom
//        slideVC.transitioningDelegate = self
//        self.present(slideVC, animated: true, completion: nil)
//    }
//    @IBAction func onButton(_ sender: Any) {
//        showMiracle()
//    }
}
//extension NewToDoViewController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        PresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}







