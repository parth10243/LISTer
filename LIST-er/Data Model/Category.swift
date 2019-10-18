//
//  Category.swift
//  LIST-er
//
//  Created by Parth on 15/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
