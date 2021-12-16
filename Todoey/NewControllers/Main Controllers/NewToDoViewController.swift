//
//  NewToDoViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 10.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class NewToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var labelOfCategory: UILabel!
    @IBOutlet weak var subcategoryOutlet: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerDataArray: Array = Array<String>()
    var pickerDataSet: Set = Set<String>()
    var sortingVar = "dateOfItemCreation"
    var subcutegoryItemVar = "note"
    var todoItems: Results<Item>?
    var abcde: String?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    var currentCategoryTransition = GlobalKonstantSingleton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        
        GlobalKonstantSingleton.selectedClassCategory = selectedCategory
        labelOfCategory.text = selectedCategory?.name
        picker.alpha = 0
        
        
//        tableView.delegate = self
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
        todoItems = selectedCategory?.items.filter("subcutegoryItem CONTAINS[cd] %@", subcutegoryItemVar).sorted(byKeyPath: sortingVar, ascending: true)
        
        pickerDataArray = selectedCategory?.items.filter("subcutegoryItem CONTAINS[cd] %@", "event").value(forKey: "dateToBeDone") as! [String]
        pickerDataSet = Set(pickerDataArray)
        
        
        
        
//        tableView.reloadData()
    }
//    func updateModel(at indexPath: IndexPath) {
//
//    }
    
    
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
        todoItems = todoItems!.filter("dateToBeDone CONTAINS[cd] %@", abcde)
        self.tableView.reloadData()
        
        
    }
    
    
    
    
    
    //MARK: - IBActions
    @IBAction func subcategorySegmentedControlIndexChanged(_ sender: UISegmentedControl) {
        switch subcategoryOutlet.selectedSegmentIndex
            {
            case 0:
            picker.alpha = 0
            subcategoryLabel.text = "Notes"
            subcutegoryItemVar = "note"
            sortingVar = "dateOfItemCreation"
            loadItems()
            tableView.reloadData()

            case 1:
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
                
                cell.titleLable.text = item.title
                cell.subtitleLabel.text = item.descriptionLable
                
                cell.needToBeDoneLabel.text = item.dateToBeDone
                cell.timeOfADatLabel.text = item.timeOfADay
                
                cell.dataOfCreation.text = item.dateOfCreationString
//                pickerData.insert(item.dateToBeDone ?? "")
                print(abcde)
                
                
                cell.accessoryType = item.done == true ? .checkmark : .none
                
            } else {
                cell.textLabel?.text = "No Items Added"
            }
            return cell
        }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handelr) in
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
//            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//                self.tableView.reloadData()
//            }
            
            handelr(true)
        }
        let swipeaction = UISwipeActionsConfiguration(actions: [action])
        return swipeaction
    }
    
    @objc func showMiracle() {
        let slideVC = OverVIewToDo()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @IBAction func onButton(_ sender: Any) {
        showMiracle()
    }
    
    
}

extension NewToDoViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}







