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
    var propertyAllImages : [PropertyAllImages]?
    var rent: Int! = 0
    var furnishingDesc: String?
    var propertySize: Int! = 0
    var bathroom: Int! = 0
    
    override func mapping(map: Map) {
        description1  <- map["description"]
        propertyTitle <- map["propertyTitle"]
        title <- map["title"]
        secondaryTitle <- map["secondaryTitle"]
        propertyAllImages <- map["photos"]
        rent <- map["rent"]
        furnishingDesc <- map["furnishingDesc"]
        propertySize <- map["propertySize"]
        bathroom <- map["bathroom"]
    }
}


/*
 
 {
 "imagesMap":{
 "thumbnail":"ff8081815b2cb5e4015b2d1ade991267_33025_thumbnail.jpg",
 "original":"ff8081815b2cb5e4015b2d1ade991267_24319_original.jpg",
 "large":"ff8081815b2cb5e4015b2d1ade991267_9073_large.jpg",
 "medium":"ff8081815b2cb5e4015b2d1ade991267_6310_medium.jpg"
 },
 "title":"",
 "name":"files[]",
 "displayPic":true
 }
 
 */

class PropertyAllImages: BaseMappableModel{
    var displayPic: Bool = false
    var imagesMap: imageMap?
    override func mapping(map: Map) {
        displayPic <- map["displayPic"]
        imagesMap <- map["imagesMap"]
    }
}


/*
 "imagesMap":{
 "thumbnail":"ff8081815b2cb5e4015b2d1ade991267_33025_thumbnail.jpg",
 "original":"ff8081815b2cb5e4015b2d1ade991267_24319_original.jpg",
 "large":"ff8081815b2cb5e4015b2d1ade991267_9073_large.jpg",
 "medium":"ff8081815b2cb5e4015b2d1ade991267_6310_medium.jpg"
 },
 */
class imageMap: BaseMappableModel{
    var thumbnail: String?
    var medium: String?
    var original: String?
    var large: String?
    
    override func mapping(map: Map) {
        thumbnail <- map ["thumbnail"]
        medium <- map["medium"]
        original <- map["original"]
        large <- map["large"]
    }
}
