//
//  Register.swift
//  Emiibo mac
//
//  Created by midyro on 11/08/2019.
//  Copyright © 2019 midyro. All rights reserved.
//

import Foundation

struct Register: Codable {
    var name: String
    var firstWriteDate: String
    var miiCharInfo: String = "mii-charinfo.bin"
}
