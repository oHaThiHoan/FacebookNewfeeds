//
//  QueryService.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit
import Alamofire

class QueryService: NSObject {

    public static func get(url: String, completion: @escaping ([String: Any]) -> Void) {
        Alamofire.request(url).responseJSON (completionHandler: { response in
            switch response.result {
            case .success:
                if let responseDict = response.result.value as? [String: Any] {
                    completion(responseDict)
                }
            case .failure(let error):
                print(error)
            }
        })
    }

}
