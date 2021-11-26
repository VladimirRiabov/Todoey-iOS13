//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 26.11.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData



class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = #colorLiteral(red: 0.0004806999268, green: 0.6455104113, blue: 1, alpha: 1)
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        
        
    }

    
//MARK: - TableView Datasource Methods
    

//MARK: - Data Manipulation Methods
    
//MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
//MARK: - TableView View Delegate Methods
    
}
