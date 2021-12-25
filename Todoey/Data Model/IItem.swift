//
//  IItem.swift
//  Todoey
//
//  Created by Владимир Рябов on 28.11.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var descriptionLable: String = ""
    @objc dynamic var dateToBeDone: String = ""
    @objc dynamic var dateToBeDoneSort: Date?
    @objc dynamic var dateOfItemCreation: Date?
    @objc dynamic var dateOfCreationString: String?
    @objc dynamic var timeOfADay: String = ""
    @objc dynamic var timeOfADaySort: Date?
    
    
    @objc dynamic var statusItem : String = ""
    @objc dynamic var subcutegoryItem : String = ""
    

    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
