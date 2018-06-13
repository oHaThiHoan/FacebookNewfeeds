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

    public static func get(view: UIView, url: String, showIndicator: Bool,
                           completion: @escaping ([String: Any]) -> Void) {
        var spinner: UIView?
        if showIndicator {
            spinner = UIViewController.displaySpinner(onView: view)
        }
        Alamofire.request(url).responseJSON (completionHandler: { response in
            switch response.result {
            case .success:
                if let responseDict = response.result.value as? [String: Any] {
                    completion(responseDict)
                }
            case .failure(let error):
                print(error)
            }
            guard let spinner = spinner else {
                return
            }
            UIViewController.removeSpinner(spinner: spinner)
        })
    }

}
