//
//  Category.swift
//  CheckList
//
//  Created by Jae-Jun Shin on 04/03/2018.
//  Copyright © 2018 Jaejun Shin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
