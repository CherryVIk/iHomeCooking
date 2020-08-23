//
//  Item.swift
//  iHomeCooking
//
//  Created by Victoria Boichenko on 23.08.2020.
//  Copyright © 2020 Victoria Boichenko. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var amount: Int = 0
    @objc dynamic var picture: String?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
