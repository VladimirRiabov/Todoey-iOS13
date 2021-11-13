//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = #colorLiteral(red: 0.0004806999268, green: 0.6455104113, blue: 1, alpha: 1)
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
//        }
}
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            
            //здесь добавили title тк теперь это ссылка на целый объект
            cell.textLabel?.text = itemArray[indexPath.row].title
           return cell
       
        }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                    if cell.accessoryType == .checkmark {
                        cell.accessoryType = .none
                    } else {
                        cell.accessoryType = .checkmark
                    }
                }
       
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    
    }
    
//MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //этот текстфилд ебется туда в алерт
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "123", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            //создает новый айтом при нажатии на кноку аддайтем
            let newItem = Item()
            
            //тк он создан из класса айтем у него есть опция текст пихаем туда текст и строки
            newItem.title = textField.text!
            
            //закидывает новый айтом в тот наш аррэй наверху
            self.itemArray.append(newItem)
            
            //перезагружает данные в тэйбле
            self.tableView.reloadData()
            
            //пихает информацию в юзер дефолтс (тут ещ> старая версия с айтемаррэй)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
}

