//
//  Common.swift
//  Emiibo mac
//
//  Created by midyro on 11/08/2019.
//  Copyright © 2019 midyro. All rights reserved.
//

import Foundation

struct Common: Codable {
    var lastWriteDate: String
    var writeCounter: Int = 0
    var version: Int = 0
}
