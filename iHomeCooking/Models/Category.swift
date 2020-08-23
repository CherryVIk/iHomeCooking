//
//  Category.swift
//  iHomeCooking
//
//  Created by Victoria Boichenko on 23.08.2020.
//  Copyright © 2020 Victoria Boichenko. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var amount: Double = 0
    @objc dynamic var price: Double = 0
    
    var items = List<Item>()
}
