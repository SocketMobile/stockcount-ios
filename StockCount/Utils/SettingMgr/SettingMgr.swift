//
//  SettingMgr.swift
//  StockCount
//
//  Created by IT Star on 12/24/17.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation

class SettingMgr {
    enum  enumKey : String{
        case autoAddQuantity        = "KEY_AutoAddQuantity"
        case supportD600            = "KEY_D600Support"
        case delineatorComma        = "KEY_DelineatorCommaSet" //1 : Comma Space Quantity, 0 : Space Quantity
        case defaultQuantity        = "KEY_DefaultQuantity"
        case newLineForNewScan      = "KEY_NewLineForNewScan"
        case vibrationOnScan        = "KEY_VibrationOnScan"
        
        case scanDate               = "KEY_ScanDate"
        case scanCount              = "KEY_ScanCount"
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
    
    class var supportD600 : Bool {
        get {return getSetting(keyName: .supportD600, typeIndicator: Bool.self) ?? false }
        set(newValue) { setSetting(keyName: .supportD600, newValue: newValue) }
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
    
    class var vibrationOnScan : Bool {
        get {return getSetting(keyName: .vibrationOnScan, typeIndicator: Bool.self) ?? false}
        set (argValue) { setSetting(keyName: .vibrationOnScan, newValue: argValue) }
    }
    
    class var scanDate : String {
        get {return getSetting(keyName: .scanDate, typeIndicator: String.self) ?? ""}
        set (argValue) { setSetting(keyName: .scanDate, newValue: argValue)}
    }
    
    class var scanCount : Int {
        get {return getSetting(keyName: .scanCount, typeIndicator: Int.self) ?? 0}
        set (argVale) { setSetting(keyName: .scanCount, newValue: argVale)}
    }
    
    
    class func getLineForBarcode(_ barcode:String? = nil) -> String {
        var strLine = barcode == nil ?  "txt_barcode".localized : barcode!
        
        if autoAddQuantity {
            if delineatorComma {
                strLine = strLine + ", \(defaultQuantity)"
            } else {
                strLine = strLine + " \(defaultQuantity)"
            }
        }
        
        let newLineSymbol = newLineForNewScan ? "\n" : ";"
        
        if let _ = barcode { //For Real Scan Data
            strLine = newLineSymbol + strLine
        } else {
            strLine = strLine + newLineSymbol
        }
        
        return strLine
    }    
}
