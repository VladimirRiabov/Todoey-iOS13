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
    @objc dynamic var needToBeDoneLable: String = ""
    @objc dynamic var dateOfItemCreation: Date?
    @objc dynamic var timeOfADay: String = ""
    @objc dynamic var timeOfADaySort: Date?
    
    
    @objc dynamic var deletedTag: String = ""
    @objc dynamic var inProcessTag: String = ""
    @objc dynamic var doneTag: String = ""
    
    
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
