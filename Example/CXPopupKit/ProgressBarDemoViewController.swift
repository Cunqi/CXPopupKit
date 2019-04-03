//
//  ProgressBarDemoViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi Xiao on 2/6/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CXPopupKit

class ProgressBarDemoViewController: UIViewController {
    @IBOutlet private weak var tapMeButton: UIButton!
    private var progress: CGFloat = 0
    private var progressBar: CXProgressBar!
    private var timer: Timer!
    private var activityIndicator: CXActivityIndicator!

    override func viewDidLoad() {
        title = "Progress Bar"
        tapMeButton.addTarget(self, action: #selector(didTapTapMeButton), for: .touchUpInside)
        var config = CXProgressConfig()
        config.progressBarSize = .medium
//        progressBar = CXProgressBar.Builder(.line).withConfig(config).create(on: self)
//        progressBar = CXProgressBar.Builder(.ring).withMessageFormat("Current progress %.0f%%").create(on: self)
        activityIndicator = CXActivityIndicator.Builder().withStyle(.large).create(on: self)
    }

    @objc private func didTapTapMeButton() {
//        self.present(progressBar, animated: true, completion: nil)
        timer = Timer(timeInterval: 8.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)

        activityIndicator.pop(on: self)
    }

    @objc private func updateProgress() {
//        progress += 0.05
//        progressBar.updateProgress(progress)
        self.activityIndicator.stopAnimating()
    }
}
