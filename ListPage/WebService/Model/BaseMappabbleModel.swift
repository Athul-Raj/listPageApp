//
//  BaseMappabbleModel.swift
//  ListPage
//
//  Created by Athul Raj on 11/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseMappableModel: NSObject, Mappable{
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
    }
    
    convenience override init() {
        self.init(args: nil)
        
    }
    
    init(args: Any?) {
        super.init()
    }
}
