//
//  ListResponseModel.swift
//  ListPage
//
//  Created by Athul Raj on 11/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit
import ObjectMapper


class ListResponseModel: BaseMappableModel{
    
    var status : Int?
    var statusCode: Int?
    var dataArray: [DataModel]?
    var otherParams: OtherParamsModel?
    
    override func mapping(map: Map) {
        status  <- map["status"]
        statusCode <- map["statusCode"]
        dataArray <- map["data"]
        otherParams <- map["otherParams"]
    }
}

