//
//  NotesViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 28.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var labelOfCategory: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    

    var sortingVar = "dateOfItemCreation"
    var todoItems: Results<Item>?
    var abcde: String?
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    var timeOfADay = ""
    var dateToBeDone = ""

    var indexPathTrailingRow = 0
    
    let startOfDay: Date = Calendar.current.startOfDay(for: Date())
    let components = DateComponents(hour: 23, minute: 59, second: 59)
    
    var itemTitle = ""
    var itemDescription = ""
    var itemDateToBeDoneSort: Date?
    var itemSubcategory = ""
    
    var itemToCreator: Item?

    override func viewDidLoad() {
        super.viewDidLoad()

        labelOfCategory.text = selectedCategory?.name
        
     
        
        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "Reusable cell")
        
        tableView.rowHeight = 80.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    

    @objc func loadList(notification: NSNotification){
        //see up
        
        self.tableView.reloadData()
        loadItems()
        
    }
    //MARK: - Loading ToDo func
    func loadItems() {
        
        todoItems = selectedCategory?.items.filter("subcutegoryItem CONTAINS[cd] %@", "note").filter("orCalendarOrTodo CONTAINS[cd] %@", "todo").sorted(byKeyPath: sortingVar, ascending: true)
        print(todoItems)
        
    }
    
    
    
    //MARK: - DataSourceMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reusable cell", for: indexPath) as! ToDoTableViewCell
        if let item = todoItems?[indexPath.row] {
            

            
            cell.status.text = item.orCalendarOrTodo
            cell.statusLabel.text = item.statusItem
            cell.titleLable.text = item.title
            cell.subtitleLabel.text = item.descriptionLable
            cell.needToBeDoneLabel.text = item.dateToBeDone
            cell.timeOfADatLabel.text = item.timeOfADay
            cell.dataOfCreation.text = item.dateOfCreationString
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            print("fdsfsdfsdfsdfsdf")
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
//    MARK: - SWIPE CELL
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

        
        let swipeActions = UISwipeActionsConfiguration(actions: [doneAction, notDoneAction])
        
        
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
            
        }
        let editorAction = UIContextualAction(style: .normal, title: "Edit") { action, view, handler in

            if let item = self.todoItems?[indexPath.row] {
                self.itemToCreator = item
                self.itemTitle = item.title
                self.itemDescription = item.descriptionLable
                self.itemDateToBeDoneSort = item.dateToBeDoneSort ?? Date()
                self.itemSubcategory = item.subcutegoryItem
                handler (true)
                self.performSegue(withIdentifier: "toItemCreatorUpdate", sender: self)
                //                    self.performSegue(withIdentifier: "toItemCreatorUpdate", sender: self)
                print(self.itemTitle, self.itemDescription)
            }
        }
        editorAction.backgroundColor = UIColor.systemBlue
        let swipeaction = UISwipeActionsConfiguration(actions: [deleteAction, editorAction])
        return swipeaction
    }
//
    //MARK: - NEW TODO ADDVIEW ITEM BLOCK
    @IBAction func toAddViewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toItemCreator", sender: self)
    }

}


   



extension NotesViewController {

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toItemCreator" {
        let destinationVC = segue.destination as! CreatorViewController

        destinationVC.selectedCategory = selectedCategory
        destinationVC.itemTitle = ""
        destinationVC.itemDescription = ""
        destinationVC.itemDateToBeDoneSort = Date()
        destinationVC.itemSubcategory = "note"
        destinationVC.creatorMode = "add"

    } else if segue.identifier == "toItemCreatorUpdate" {
        let destinationVC = segue.destination as! CreatorViewController
        destinationVC.selectedCategory = selectedCategory
        destinationVC.itemTitle = itemTitle
        destinationVC.itemDescription = itemDescription
        destinationVC.itemDateToBeDoneSort = itemDateToBeDoneSort ?? Date()
        destinationVC.itemSubcategory = itemSubcategory
        destinationVC.item = itemToCreator
        destinationVC.creatorMode = "update"

        print("sequae edit is performed")

    }
}
}
