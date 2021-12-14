//
//  TrashViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 14.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TrashViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
   
    let realm = try! Realm()
    var categories: Results<Category>?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Reusable cell")
        tableView.rowHeight = 80.0
        loadCategories()
        //MARK: - Observer from OverlayView
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func loadList(notification: NSNotification){
        //see up
        self.tableView.reloadData()
    }
    //MARK: - Loading and Saving Categories funcs
   public func loadCategories() {
//       todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
       categories = realm.objects(Category.self).filter("statusCategory CONTAINS[cd] %@", "deleted")
        tableView.reloadData()
    }
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error while encoding \(error)")
        }
        tableView.reloadData()
    }
    //MARK: - IBActions

    @IBAction func Butt(_ sender: UIButton) {
        performSegue(withIdentifier: "toTrash", sender: self)
    }
    
}

//MARK: - DataSourceMethods
extension TrashViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reusable cell", for: indexPath) as! CategoryTableViewCell
        cell.categoryTitleLabel.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        if let countItems = categories?[indexPath.row].items.count {
            cell.numberOfItemsLabel.text = String(countItems)
        }
        cell.dateOfCreationLAbel.text = categories?[indexPath.row].dateOfCreationString
        
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handelr) in
            print("delete")
            if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
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
}

extension TrashViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "toTheItems", sender: self)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toTheItems" {
//            let destinationVC = segue.destination as! NewToDoViewController
//            if let indexPath = tableView.indexPathForSelectedRow {
//                destinationVC.selectedCategory = categories?[indexPath.row]
            }
