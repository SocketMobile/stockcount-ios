//
//  DBHelper.swift
//  InventoryUtility
//
//  Created by IT Star on 12/28/17.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import RealmSwift

class DBHelper {
    class func updateFile(fileName : String, fileTitle : String , firstScan : String) {
        let realm = try! Realm()
        
        if let item = realm.object(ofType: RMFile.self, forPrimaryKey: fileName) {
            try! realm.write {
                item.fileTitle = fileTitle
                item.firstScan = firstScan
                item.updatedTime = Date()
            }

        }else{
            let newItem = RMFile()
            
            newItem.fileName = fileName
            newItem.fileTitle = fileTitle
            newItem.firstScan = firstScan
            newItem.updatedTime = Date()
            
            try! realm.write {
                realm.add(newItem, update: true)
            }
        }
    }
    
    class func deleteFile(fileName : String) {
        let realm = try! Realm()
        
        if let realmItem = realm.object(ofType: RMFile.self, forPrimaryKey: fileName) {
            try! realm.write {
                realm.delete(realmItem)
            }
        }
    }
}
