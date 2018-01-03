//
//  Date.swift
//  InventoryUtility
//
//  Created by IT Star on 12/28/17.
//  Copyright © 2017 Simple Design Inc. All rights reserved.
//

import Foundation
public extension Date {
    func toStringWithFormat(_ format : String) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        //        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self as Date)
    }
}
