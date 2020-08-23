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
    @objc dynamic var amount: Int?
    @objc dynamic var price: Float?
    
    var items = List<Item>()
}
