//
//  UILoadingTableView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/14/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class UILoadingTableView: UITableView {

    var loadingView = UIView()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        addLoadingView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addLoadingView()
    }

    private func addLoadingView() {
        loadingView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(loadingView)
    }

}
