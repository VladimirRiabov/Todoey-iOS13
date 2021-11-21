//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = #colorLiteral(red: 0.0004806999268, green: 0.6455104113, blue: 1, alpha: 1)
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        
        loadItems()

}
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            
            
            
            //сделали код чуть красивее
            let item = itemArray[indexPath.row]
            
            cell.textLabel?.text = item.title
            
            
            // продолжение. и уже в зависимости от того что в этот дан впихнули делаеаем различное отображение ячейки
            
            //Ternary operator ==>
            //value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
//            if itemArray[indexPath.row].done == true {
//                cell.accessoryType = .checkmark
//            } else {
//                cell.accessoryType = .none
//            }
            
           return cell
       
        }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //код который меняет значение в опции дан см блок выше для продоллжения
                
        
        //это выражение инвертирует значение автоматически при выделении ячейки
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        // этот метод и заствляет эти два метода дата сурса снова запуститься
        tableView.reloadData()
        
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    
    }
    
//MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //этот текстфилд ебется туда в алерт
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "123", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            //закидывает новый айтом в тот наш аррэй наверху
            self.itemArray.append(newItem)
            
          
            self.saveItems()
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
    
    
    
    func saveItems() {
        
        
        do {
            
            try context.save()
        } catch {
            print("Error while encoding \(error)")
        }
        
        self.tableView.reloadData()
    }
    

    func loadItems() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
            
        } catch {
            print(error)
        }
    }

    
    
    
}




