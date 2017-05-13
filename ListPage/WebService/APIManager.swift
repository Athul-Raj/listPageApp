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

    
    static func fetchAllRooms(with pagenumber:String, and filter:String, completion: @escaping ([String:Any]?) -> Void) {
        Alamofire.request(
            
            URL(string: API.listFetchBaseURL+"\(pagenumber)" + filter)!,
            method: .get,
            parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    // No network error display  here..
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    print("Malformed data received from fetchAllRooms service")
                    completion(nil)
                    return
                }

                print(value["status"]!)
                completion(value)
        }
    }

}
