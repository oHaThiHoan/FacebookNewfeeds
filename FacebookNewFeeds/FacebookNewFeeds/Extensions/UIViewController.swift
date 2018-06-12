//
//  UIViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/31/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let colorSpinner = "#E0E0E0"
}

extension UIViewController {

    class func displaySpinner(onView: UIView) -> UIView {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        spinnerView.backgroundColor = UIColor(hexString: Constants.colorSpinner)
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }

        return spinnerView
    }

    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }

}
