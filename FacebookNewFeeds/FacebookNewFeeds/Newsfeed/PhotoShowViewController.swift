//
//  PhotoShowViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/20/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class PhotoShowViewController: UIViewController {

    @IBOutlet weak var videoView: VideoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.configure(url: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        videoView.play()
    }

}
