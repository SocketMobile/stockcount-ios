//
//  SettingMgr.swift
//  InventoryUtility
//
//  Created by IT Star on 12/24/17.
//  Copyright © 2017 Simple Design Inc. All rights reserved.
//

import Foundation

class SettingMgr {
    enum  enumKey : String{
        case autoAddQuantity = "KEY_AutoAddQuantity"
        case delineatorComma = "KEY_DelineatorCommaSet" //1 : Comma Space Quantity, 0 : Space Quantity
        case defaultQuantity = "KEY_DefaultQuantity"
        case newLineForNewScan = "KEY_NewLineForNewScan"
//        case semiColonBeforeNewScan = "KEY_SemiColonBeforeNewScan"
    }
    
    static let key_AutoAddQuantity = "KEY_AutoAddQuantity"
    
    private class func getSetting<T>(keyName : enumKey, typeIndicator : T.Type) -> T? {
        let userDefault = UserDefaults.standard
        
        if let value = userDefault.object(forKey: keyName.rawValue) {
            return value as? T
        }
        return nil
    }
    
    private class func setSetting<T>(keyName : enumKey, newValue : T) {
        let userDefault = UserDefaults.standard
        userDefault.set(newValue, forKey: keyName.rawValue)
    }
    
    class var autoAddQuantity : Bool{
        get {return getSetting(keyName: .autoAddQuantity, typeIndicator: Bool.self) ?? true }
        set(newValue) { setSetting(keyName: .autoAddQuantity, newValue: newValue) }
    }
    
    class var delineatorComma : Bool {
        get {return getSetting(keyName: .delineatorComma, typeIndicator: Bool.self) ?? true}
        set (argValue) { setSetting(keyName: .delineatorComma, newValue: argValue) }
    }
    
    class var defaultQuantity : Int {
        get {return getSetting(keyName: .defaultQuantity, typeIndicator: Int.self) ?? 1}
        set (argValue) {setSetting(keyName: .defaultQuantity, newValue: argValue)}
    }
    
    class var newLineForNewScan : Bool {
        get {return getSetting(keyName: .newLineForNewScan, typeIndicator: Bool.self) ?? true}
        set (argValue) {setSetting(keyName: .newLineForNewScan, newValue: argValue)}
    }
    
    
    class func getLineForBarcode(_ barcode:String? = nil) -> String {
        var strLine = barcode == nil ?  "[barcode]" : barcode!
        
        if autoAddQuantity {
            if delineatorComma {
                strLine = strLine + ", \(defaultQuantity)"
            } else {
                strLine = strLine + " \(defaultQuantity)"
            }
        }
        
        if newLineForNewScan {
            strLine = strLine + "\n"
        } else {
            strLine = strLine + ";"
        }
        
        return strLine
    }
    
//    class var semiColonBeforeNewScan : Bool {
//        get {return getSetting(keyName: .semiColonBeforeNewScan, typeIndicator: Bool.self) ?? false}
//        set (argValue) {setSetting(keyName: .semiColonBeforeNewScan, newValue: argValue)}
//    }
}
