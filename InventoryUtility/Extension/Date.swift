//
//  Date.swift
//  InventoryUtility
//
//  Created by IT Star on 12/28/17.
//  Copyright © 2017 Socket Mobile, Inc.
//

import Foundation
public extension Date {
    func toStringWithFormat(_ format : String) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}
