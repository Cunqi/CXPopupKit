//
//  DemoPlaygroundViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 3/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import SnapKit
import UIKit

class DemoPlaygroundViewController: UIViewController {
    private var openButton: UIButton!
    private var pickAnimationTypeButton: UIButton!
    private var pickAnimationTransitionButton: UIButton!
    private var pickAnimationDurationButton: UIButton!
    private var pickSafeAreaPolicyButton: UIButton!
    private var pickSizeButton: UIButton!
    private var pickPositionButton: UIButton!
    
    private let popupStyle = CXPopupStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Basic Demo"
        
        openButton = UIButton(type: .system)
        pickAnimationTypeButton = UIButton(type: .system)
        pickAnimationTransitionButton = UIButton(type: .system)
        pickAnimationDurationButton = UIButton(type: .system)
        pickSafeAreaPolicyButton = UIButton(type: .system)
        pickSizeButton = UIButton(type: .system)
        pickPositionButton = UIButton(type: .system)
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        view.backgroundColor = .white
        view.addSubview(openButton)
        
        openButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(16)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
            maker.height.equalTo(44)
        }
        
        openButton.setTitle("Open Popup", for: .normal)
        openButton.setTitleColor(.white, for: .normal)
        openButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        openButton.backgroundColor = view.tintColor
        openButton.layer.cornerRadius = 8
        openButton.addTarget(self, action: #selector(didTapOpenPopupButton), for: .touchUpInside)
        
        pickSafeAreaPolicyButton.setTitle("Safe Area", for: .normal)
        pickSafeAreaPolicyButton.addTarget(self, action: #selector(didTapPickSafeAreaButton), for: .touchUpInside)
        
        let dimensionStackView = UIStackView(arrangedSubviews: [pickSafeAreaPolicyButton, pickSizeButton, pickPositionButton])
        let animationStackView = UIStackView(arrangedSubviews: [pickAnimationTypeButton, pickAnimationDurationButton, pickAnimationTransitionButton])
        let othersStackView = UIStackView()
        
        let gridStackView = UIStackView(arrangedSubviews: [dimensionStackView, animationStackView, othersStackView])
        gridStackView.axis = .vertical
        gridStackView.distribution = .fillEqually
        gridStackView.spacing = 1.0
        gridStackView.alignment = .fill
        
        view.addSubview(gridStackView)
        gridStackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.8)
            maker.height.equalTo(gridStackView.snp.width)
        }
        
        for stackView in gridStackView.arrangedSubviews {
            if let stackView = stackView as? UIStackView {
                stackView.axis = .horizontal
                stackView.spacing = 1.0
                stackView.distribution = .fillEqually
                for subview in stackView.arrangedSubviews {
                    if let button = subview as? UIButton {
                        button.layer.cornerRadius = 6.0
                        button.backgroundColor = button.tintColor
                        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
                        button.setTitleColor(.white, for: .normal)
                    }
                }
            }
        }
    }
    
    @objc
    private func didTapPickSafeAreaButton() {
        
    }
    
    @objc
    private func didTapOpenPopupButton() {
        let popupController = CXPopupController(self, DemoPopupViewController(), popupStyle) {
            print("Dismissed")
        }
        present(popupController, animated: true, completion: nil)
    }
}
