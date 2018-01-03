//
//  DBHelper.swift
//  InventoryUtility
//
//  Created by IT Star on 12/28/17.
//  Copyright © 2017 Simple Design Inc. All rights reserved.
//

import Foundation
import RealmSwift

class DBHelper {
    /*static let sharedInstance : DBHelper = {
        let instance = DBHelper()
        return instance
    }()*/
    
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
