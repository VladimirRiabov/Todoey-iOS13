//
//  ChoiceViewController.swift
//  Todoey
//
//  Created by Владимир Рябов on 28.12.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit



class ChoiceViewController: UIViewController {
    
    var selectedCategory : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
print(selectedCategory)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChoiceViewController {
    

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toEvents" {
        let destinationVC = segue.destination as! EventsViewController
        destinationVC.selectedCategory = selectedCategory

    } else if segue.identifier == "toNotes" {
        let destinationVC = segue.destination as! NotesViewController
        destinationVC.selectedCategory = selectedCategory


    }
}
}
