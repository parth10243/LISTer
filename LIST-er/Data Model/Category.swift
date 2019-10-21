//
//  Category.swift
//  LIST-er
//
//  Created by Parth on 15/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var rowColour : String = UIColor.randomFlat().hexValue()
    let items = List<Item>()
}
