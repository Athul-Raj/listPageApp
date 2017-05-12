//
//  APIManager.swift
//  ListPage
//
//  Created by Athul Raj on 11/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {

    
    static func fetchAllRooms(with pagenumber:String, completion: @escaping ([String:Any]?) -> Void) {
        Alamofire.request(
            
            
            URL(string: "http://www.nobroker.in/api/v1/property/filter/region/ChIJLfyY2E4UrjsRVq4AjI7zgRY/?lat_lng=12.9279232,77.6271078&rent=0,500000&travelTime=30&pageNo=\(pagenumber)")!,
            method: .get,
            parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    print("Malformed data received from fetchAllRooms service")
                    completion(nil)
                    return
                }
                /*
                 let rooms = rows.flatMap({ (roomDict) -> RemoteRoom? in
                 return RemoteRoom(jsonData: roomDict)
                 })*/
                
                print(value["status"]!)
                completion(value)
        }
    }

}
