//
//  Item.swift
//  CheckList
//
//  Created by Jae-Jun Shin on 04/03/2018.
//  Copyright © 2018 Jaejun Shin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Data?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
