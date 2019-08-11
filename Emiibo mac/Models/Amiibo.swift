//
//  Amiibo.swift
//  Emiibo mac
//
//  Created by midyro on 10/08/2019.
//  Copyright © 2019 midyro. All rights reserved.
//

import Foundation

struct Amiibo: Codable {
    var amiiboSeries: String
    var character, gameSeries, head: String
    var image: String
    var name: String
//    var release: Release
    var tail: String
    var type: String
}


struct Release : Codable{
    var au: String
    var eu: String
    var jp: String
    var na: String
}
