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

    public static func get(context: UIViewController, url: String, completion: @escaping ([String: Any]) -> Void) {
        let spinner = UIViewController.displaySpinner(onView: context.view)
        Alamofire.request(url).responseJSON (completionHandler: { response in
            switch response.result {
            case .success:
                if let responseDict = response.result.value as? [String: Any] {
                    completion(responseDict)
                    UIViewController.removeSpinner(spinner: spinner)
                }
            case .failure(let error):
                UIViewController.removeSpinner(spinner: spinner)
                print(error)
            }
        })
    }

}
