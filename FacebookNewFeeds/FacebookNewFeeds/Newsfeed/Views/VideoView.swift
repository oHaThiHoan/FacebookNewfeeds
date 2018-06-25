//
//  VideoView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/20/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

private struct Constants {
    public static let videoViewNibName = "VideoView"
}

class VideoView: UIView {

    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    var spinner: UIView?
    var observation: NSKeyValueObservation?
    @IBOutlet weak var pauseImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        pauseImageView.layer.zPosition = 1
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pauseImageView.isHidden {
            pause()
        } else {
            play()
        }
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.playerLayer?.frame = self.bounds
    }

    func configure(url: String) {
        spinner = UIViewController.displaySpinner(onView: self)
        DispatchQueue.global(qos: .background).async {
            if let videoURL = URL(string: url) {
                let playerItem = AVPlayerItem(url: videoURL)
                self.player = AVPlayer(playerItem: playerItem)
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerLayer?.videoGravity = .resizeAspectFill
                self.observation = playerItem.observe(\AVPlayerItem.playbackLikelyToKeepUp, options: [.new]) { _, _ in
                    if let spinner = self.spinner {
                        UIViewController.removeSpinner(spinner: spinner)
                    }
                    self.play()
                }
                DispatchQueue.main.async {
                    if let playerLayer = self.playerLayer {
                        self.layer.addSublayer(playerLayer)
                    }
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }

    func play() {
        if player?.timeControlStatus != AVPlayerTimeControlStatus.playing {
            player?.play()
            pauseImageView.isHidden = true
        }
    }

    func pause() {
        player?.pause()
        pauseImageView.isHidden = false
    }

    func stop() {
        player?.pause()
        player?.seek(to: kCMTimeZero)
        pauseImageView.isHidden = false
    }

    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: kCMTimeZero)
            player?.play()
        } else {
            stop()
        }
    }

    deinit {
        player?.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }

}
