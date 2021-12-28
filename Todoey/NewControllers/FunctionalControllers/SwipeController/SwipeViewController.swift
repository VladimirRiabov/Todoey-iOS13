//
//  SwipeViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 28.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class SwipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (contextualAction, view, boolValue) in
            
            
            
            //блок дочерний раз
            print("DONE")
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
            
            
            boolValue(true) // pass true if you want the handler to allow the action
            print("Leading Action style .normal")
            tableView.reloadData()
        }
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        let notDoneAction = UIContextualAction(style: .normal, title: "Not done") { (contextualAction, view, boolValue) in
            
            //блок дочерний два
            print("NOTE DONE")
//            if let item = self.todoItems?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        item.statusItem = "Not done"
//                    }
//                } catch {
//                    print("Error while encoding \(error)")
//                }
//            }
            
            
            boolValue(true) // pass true if you want the handler to allow the action
            
            tableView.reloadData()
        }
        
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        notDoneAction.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        //блок дочерний три
//        if subcategorySegmentedControlIndex == 1 {
//            swipeActions = UISwipeActionsConfiguration(actions: [doneAction, notDoneAction])
//        } else {
//            swipeActions = UISwipeActionsConfiguration(actions: [])
//        }
        let swipeActions = UISwipeActionsConfiguration(actions: [doneAction, notDoneAction])
        
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handelr) in
           
            
            //блок дочерний четыре
            print("DELETE CELL")
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
            handelr(true)
//            self.loadItems()
//            self.abcde = self.pickerDataSet.sorted(by: <).last
//            self.picker.delegate = self
//            self.tableView.reloadData()
            
        }
        let editorAction = UIContextualAction(style: .normal, title: "Edit") { action, view, handler in
            
            //блок дочерний пять
            print("EDIT CELL")
//            if let item = self.todoItems?[indexPath.row] {
//                self.itemToCreator = item
//                self.itemTitle = item.title
//                self.itemDescription = item.descriptionLable
//                self.itemDateToBeDoneSort = item.dateToBeDoneSort ?? Date()
//                self.itemSubcategory = item.subcutegoryItem
                handler (true)
//                self.performSegue(withIdentifier: "toItemCreatorUpdate", sender: self)

            }
        editorAction.backgroundColor = UIColor.systemBlue
        let swipeaction = UISwipeActionsConfiguration(actions: [deleteAction, editorAction])
        return swipeaction
        }
        
    }


