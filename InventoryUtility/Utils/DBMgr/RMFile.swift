//
//  RMFile.swift
//  InventoryUtility
//
//  Created by IT Star on 12/23/17.
//  Copyright © 2017 Simple Design Inc. All rights reserved.
//

import Foundation
import RealmSwift

class RMFile: Object {
    @objc dynamic var fileName = ""
    @objc dynamic var addedDate = Date()
    @objc dynamic var firstLine = ""
}
