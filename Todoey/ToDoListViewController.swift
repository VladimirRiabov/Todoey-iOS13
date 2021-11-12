//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = #colorLiteral(red: 0.0004806999268, green: 0.6455104113, blue: 1, alpha: 1)

        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
}
//
//
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return itemArray.count
        }

        // Provide a cell object for each row.
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // Fetch a cell of the appropriate type.
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
           
           // Configure the cell’s contents.
           cell.textLabel?.text = itemArray[indexPath.row]
               
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
    


}

