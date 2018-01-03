//
//  String.swift
//  InventoryUtility
//
//  Created by IT Star on 12/28/17.
//  Copyright © 2017 Simple Design Inc. All rights reserved.
//

import Foundation
public extension String {
    var lines : [String] {
        var result: [String] = []
        enumerateLines{line, _ in result.append(line)}
        return result
    }
}
