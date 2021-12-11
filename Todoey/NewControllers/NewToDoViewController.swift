//
//  NewToDoViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 10.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class NewToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "Reusable cell")

    }
    //MARK: - Loading ToDo func
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        print(todoItems)
//        tableView.reloadData()
    }
//    func updateModel(at indexPath: IndexPath) {
//
//    }
    
    //MARK: - IBActions
    @IBAction func addNewItemButtonPressed(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
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

//MARK: - DataSourceMethods
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Reusable cell", for: indexPath) as! ToDoTableViewCell
            if let item = todoItems?[indexPath.row] {
                cell.titleLable.text = item.title
                cell.accessoryType = item.done == true ? .checkmark : .none
                print("arbeitet")
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







