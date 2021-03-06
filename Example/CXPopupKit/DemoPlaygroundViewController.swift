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

        pickSizeButton.setTitle("Size", for: .normal)
        pickSizeButton.addTarget(self, action: #selector(didTapPickSizeButton), for: .touchUpInside)

        pickPositionButton.setTitle("Position", for: .normal)
        pickPositionButton.addTarget(self, action: #selector(didTapPickPositionButton), for: .touchUpInside)
        
        pickAnimationTypeButton.setTitle("Style", for: .normal)
        pickAnimationTypeButton.addTarget(self, action: #selector(didTapPickAnimationTypeButton), for: .touchUpInside)
        
        pickAnimationTransitionButton.setTitle("Transition", for: .normal)
        pickAnimationTransitionButton.addTarget(self, action: #selector(didTapPickAnimationTransitionButton), for: .touchUpInside)
        
        let dimensionStackView = UIStackView(arrangedSubviews: [pickSafeAreaPolicyButton, pickSizeButton, pickPositionButton])
        let animationStackView = UIStackView(arrangedSubviews: [pickAnimationTypeButton, pickAnimationTransitionButton, UIView()])
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
    private func didTapOpenPopupButton() {
        let popupController = CXPopupController(self, DemoPopupViewController(), popupStyle)
        popupController.style.backgroundColor = .orange
        present(popupController, animated: true, completion: nil)
    }

    @objc
    private func didTapPickSafeAreaButton() {
        let safeAreaVC = DemoSafeAreaPickViewController()
        let popupController = CXPopupController(self, safeAreaVC.wrapped, popupStyle) {
            self.popupStyle.safeAreaPolicy = CXSafeAreaPolicy(rawValue: safeAreaVC.picker.selectedRow(inComponent: 0)) ?? .system
        }
        popupController.style = CXPopupStyle.style(axisY: .bottom)
        popupController.style.height = .fixed(240)
        popupController.style.safeAreaPolicy = .auto
        popupController.style.backgroundColor = .white
        present(popupController, animated: true, completion: nil)
    }

    @objc
    private func didTapPickSizeButton() {
        let sizeVC = DemoSizePickerViewController()
        let popupController = CXPopupController(self, sizeVC.wrapped, popupStyle) {
            self.popupStyle.width = CXEdge.value(from: sizeVC.picker.selectedRow(inComponent: 0))
            self.popupStyle.height = CXEdge.value(from: sizeVC.picker.selectedRow(inComponent: 1))
            print(self.popupStyle)
        }
        popupController.style = CXPopupStyle.style(axisY: .bottom)
        popupController.style.height = .fixed(240)
        popupController.style.safeAreaPolicy = .auto
        popupController.style.backgroundColor = .white
        present(popupController, animated: true, completion: nil)
    }

    @objc
    private func didTapPickPositionButton() {
        let positionVC = DemoPositionPickerViewController()
        let popupController = CXPopupController(self, positionVC.wrapped, popupStyle) {
            let x = CXAxisX.value(from: positionVC.picker.selectedRow(inComponent: 0))
            let y = CXAxisY.value(from: positionVC.picker.selectedRow(inComponent: 1))
            self.popupStyle.position = CXPosition(x, y)
        }
        popupController.style = CXPopupStyle.style(axisY: .bottom)
        popupController.style.height = .fixed(240)
        popupController.style.safeAreaPolicy = .auto
        popupController.style.backgroundColor = .white
        present(popupController, animated: true, completion: nil)
    }
    
    @objc
    private func didTapPickAnimationTypeButton() {
        let animationTypeVC = DemoAnimationTypePickerViewController()
        let popupController = CXPopupController(self, animationTypeVC.wrapped, popupStyle) {
            self.popupStyle.animationType = CXAnimationType.value(for: animationTypeVC.picker.selectedRow(inComponent: 0))
        }
        popupController.style = CXPopupStyle.style(axisY: .bottom)
        popupController.style.height = .fixed(240)
        popupController.style.safeAreaPolicy = .auto
        popupController.style.backgroundColor = .white
        present(popupController, animated: true, completion: nil)
    }
    
    @objc
    private func didTapPickAnimationTransitionButton() {
        let animationTransitionVC = DemoAnimationTransitionPickerViewController()
        let popupController = CXPopupController(self, animationTransitionVC.wrapped, popupStyle) {
            let animationIn = CXAnimationDirection.value(from: animationTransitionVC.picker.selectedRow(inComponent: 0))
            let animationOut = CXAnimationDirection.value(from: animationTransitionVC.picker.selectedRow(inComponent: 1))
            self.popupStyle.animationTransition = CXAnimationTransition(animationIn, animationOut)
        }
        popupController.style = CXPopupStyle.style(axisY: .bottom)
        popupController.style.height = .fixed(240)
        popupController.style.safeAreaPolicy = .auto
        popupController.style.backgroundColor = .white
        present(popupController, animated: true, completion: nil)
    }
}
