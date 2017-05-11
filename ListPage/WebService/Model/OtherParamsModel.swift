//
//  OtherParamsModel.swift
//  ListPage
//
//  Created by Athul Raj on 11/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit
import ObjectMapper

class OtherParamsModel: BaseMappableModel {
    
    var city : String?
    var count : Int?
    var totalCount: Int?
    
    override func mapping(map: Map) {
        city  <- map["city"]
        count <- map["count"]
        totalCount <- map["total_count"]
    }
    
    /*
 city = bangalore;
 count = 21;
 "region_id" = ChIJLfyY2E4UrjsRVq4AjI7zgRY;
 searchToken = "<null>";
 topPropertyId = "<null>";
 "total_count" = 148;*/
}
