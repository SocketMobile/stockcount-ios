//
//  RefersionKeys.swift
//  StockCount
//
//  Created by gold on 2019/4/15.
//  Copyright © 2019 Simple Design Inc. All rights reserved.
//

import Foundation

let REGION_CHINA = "CN"
let REGION_DEFAULT = "DEFAULT"

let ChinaLink = "https://www.amazon.cn/dp/B01N8SQ8MU/ref=sr_1_7?__mk_zh_CN=%E4%BA%9A%E9%A9%AC%E9%80%8A%E7%BD%91%E7%AB%99&keywords=socket+mobile&qid=1555606674&s=gateway&sr=8-7"
let EuroCodes = ["AL", "AD", "AM", "AT", "BY", "BE", "BA", "BG", "CH", "CY", "CZ", "DE", "DK", "EE", "ES", "FO", "FI", "FR", "GE", "GI", "GR", "HU", "HR", "IE", "IS", "IT", "LT", "LU", "LV", "MC", "MK", "MT", "NO", "NL", "PO", "PT"]
var DefaultKey = (pub_key: "pub_9a42760dc57269d2f616", sec_key: "", aff_code: "7daad6")
var Key = [
    "JP"        : (pub_key: "pub_0fa9f9c60fb103ec2c71", sec_key: "", aff_code: "5413c4"),
    "AU"        : (pub_key: "pub_9c09ee1b0154d56d2cdd", sec_key: "", aff_code: "b922b8"),
    "GB"        : (pub_key: "pub_d76b55562cc316faec74", sec_key: "", aff_code: "5462fa"),
    "EMEA"      : (pub_key: "pub_81784e9af147411559cb", sec_key: "", aff_code: "4fc514")
]

func getRefersionKeys(_ regionCode: String) -> (pub_key: String, sec_key: String, aff_code: String) {
    var result: (pub_key: String, sec_key: String, aff_code: String)? = nil
    if EuroCodes.firstIndex(of: regionCode) != nil {
        result = Key["EMEA"]
    } else {
        result = Key[regionCode]
    }
    if result == nil {
        result = DefaultKey
    }
    return result!
}

func retrieveSecKeyValues() {
    if let path = Bundle.main.path(forResource: "SecKeys", ofType: "plist") {
        if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
            dict.forEach { (arg0) in
                let (regionKey, value) = arg0
                if regionKey == REGION_DEFAULT {
                    DefaultKey.sec_key = value as! String
                } else if let _ = Key[regionKey] {
                    Key[regionKey]?.sec_key = value as! String
                }
            }
        }
    }
}
