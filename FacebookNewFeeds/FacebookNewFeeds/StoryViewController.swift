//
//  StoryViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/13/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit
private struct Constants {
    public static let timeIntervalProgessView = 0.1
    public static let intervalProgressView = 0.01
    public static let maxProgessView = 1.0
}

protocol StoryViewControllerDelegate: class {
    func exitAction()
    func goToNextPage()
}

class StoryViewController: UIViewController {

    var index: Int = 0
    var storyModel: StoryModel?
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var storyImageView: UIImageView!
    weak var delegate: StoryViewControllerDelegate?
    var value = 0.0
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let storyModel = storyModel, let imageUrl = storyModel.storyImageUrl else {
            return
        }
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.setImageFromStringURL(stringURL: imageUrl)
        storyImageView.setImageFromStringURL(stringURL: imageUrl)
        fullNameLabel.text = storyModel.fullName
        progressView.progress = Float(value)
        timer = Timer.scheduledTimer(timeInterval: Constants.timeIntervalProgessView, target: self,
            selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }

    @objc func updateProgressView() {
        value += Constants.intervalProgressView
        progressView.progress = Float(value)
        if value > Constants.maxProgessView {
            timer.invalidate()
            delegate?.goToNextPage()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }

    @IBAction func exitAction(_ sender: Any) {
        delegate?.exitAction()
    }

}
