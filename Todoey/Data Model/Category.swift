//
//  Category.swift
//  Todoey
//
//  Created by Владимир Рябов on 28.11.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var dateOfCreation : Date?
    @objc dynamic var dateOfCreationString : String = ""
    @objc dynamic var descriptionOfCategory : String = ""
    @objc dynamic var whenItNeedsToDo : String = ""
    @objc dynamic var statusCategory : String = ""
    
    let items = List<Item>()
    
}
