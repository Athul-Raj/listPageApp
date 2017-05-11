//
//  DataModel.swift
//  ListPage
//
//  Created by Athul Raj on 11/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit
import ObjectMapper

class DataModel:  BaseMappableModel{
    
    var description1 : String?
    var propertyTitle : String?
    var title : String?
    var secondaryTitle : String?
    
    override func mapping(map: Map) {
        description1  <- map["description"]
        propertyTitle <- map["propertyTitle"]
        title <- map["title"]
        secondaryTitle <- map["secondaryTitle"]
    }
}
