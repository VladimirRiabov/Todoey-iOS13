//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()

        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = #colorLiteral(red: 0.0004806999268, green: 0.6455104113, blue: 1, alpha: 1)
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance

}

//MARK: - TableView Datasource Methods
    
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoCell
            
            if let item = todoItems?[indexPath.row] {
                cell.titleLabel.text = item.title
                cell.accessoryType = item.done == true ? .checkmark : .none
            } else {
                cell.textLabel?.text = "No Items Added"
            }
            
           return cell
       
        }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error while encoding \(error)")
                }
            }
//            print("index path of delete: \(indexPath)")
            completionHandler(true)
           
                tableView.reloadData()
            
        }

        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    //MARK: - TableView Delegate Methods
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
            }
            } catch {
                print("Error saving done status\(error)")
            }
        }
        

        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)



    }
    
//MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "123", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                        
                    newItem.dateOfItemCreation = Date()
                   
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving")
                }
            }
            

            self.tableView.reloadData()


        }

        alert.addAction(action)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"

            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }

    //MARK - Model Manipulation Methods


//

    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    
    
    
}

//MARK - SearchBar Methods

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
       
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()

            DispatchQueue.main
            searchBar.resignFirstResponder()

        }
    }

}




