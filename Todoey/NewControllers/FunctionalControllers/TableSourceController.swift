//
//  TableSourceController.swift
//  Todoey
//
//  Created by Владимир Рябов on 28.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TableSourceController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let startOfDay: Date = Calendar.current.startOfDay(for: Date())
    let components = DateComponents(hour: 23, minute: 59, second: 59)
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "Reusable cell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reusable cell", for: indexPath) as! ToDoTableViewCell
        
        return cell
    }

}

