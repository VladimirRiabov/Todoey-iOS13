//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 26.11.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryViewController: UITableViewController {
    
//    @IBOutlet weak var searchBar: xUISearchBar!
    let realm = try! Realm()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(dataFilePath)
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = #colorLiteral(red: 0.0004806999268, green: 0.6455104113, blue: 1, alpha: 1)
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        loadCategories()
        
    }

    
//MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
//        cell.accessoryType = item.done == true ? .checkmark : .none
//
////            if itemArray[indexPath.row].done == true {
////                cell.accessoryType = .checkmark
////            } else {
////                cell.accessoryType = .none
////            }
        
       return cell
   
    }
    

//MARK: - Data Manipulation Methods
    
    
    func save(category: Category) {
                
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error while encoding \(error)")
        }
        
        self.tableView.reloadData()
    }
    

    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        print("abcfdfsdfsdfsdf")
        do {
            categoryArray = try context.fetch(request)
            
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
//
//
//    }
//
    
    
//MARK: - Add New Categories
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "123", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in

            
            let newCategory = Category()
            newCategory.name = textField.text!
//            newCategory.done = false
            
            //закидывает новый айтом в тот наш аррэй наверху
            self.categoryArray.append(newCategory)
            
          
            self.save(category: newCategory)
            //перезагружает данные в тэйбле
            self.tableView.reloadData()
            
           
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
        
    
    
//MARK: - TableView View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
