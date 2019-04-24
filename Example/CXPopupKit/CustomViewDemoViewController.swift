//
//  CustomViewDemoViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 1/29/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CXPopupKit

class CustomViewDemoViewController: UIViewController {
    @IBOutlet private weak var tapMeButton: UIButton!
    
    private static let customViewSize = CGSize(width: 200, height: 200)
    private var customView = CustomView()
    private var config = CXPopupAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigator()
        tapMeButton.addTarget(self, action: #selector(didTapTapMeButton), for: .touchUpInside)
        
        customView.backgroundColor = UIColor(red: 1, green: 126 / 255.0, blue: 121 / 255.0, alpha: 1.0)

        config.layoutStyle = .bottomLeft(size: CustomViewDemoViewController.customViewSize)
        config.animationStyle = .bounce
        config.animationTransition = CXAnimationTransition(.down)
        config.safeAreaStyle = .on
        config.isAutoRotateEnabled = true
    }

    private func setupNavigator() {
        title = "CustomView"
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc private func didTapTapMeButton() {
//        CXPopupController(customView, appearance: config).pop(on: self)
        let popupAppearance: CXPopupAppearance = {
            var popupAppearance = CXPopupAppearance()
            popupAppearance.layoutStyle = .bottom(height: 0)
            popupAppearance.animationStyle = .fade
            popupAppearance.animationTransition = CXAnimationTransition(.up, .down)
            popupAppearance.safeAreaStyle = .wrap
            popupAppearance.safeAreaGapColor = .red
            return popupAppearance
        }()

        let array = [
            "Top",
            "TopLeft",
        ]


        CXListPicker<String>(items: array, selectedItem: "Right", popupAppearance: popupAppearance, handler: nil)
            .pop(on: self)
    }
    
    
    @IBAction func didTapLayoutBarButtonItem(_ sender: Any) {
        let array = [
            "Top",
            "TopLeft",
            "TopRight",
            "TopCenter",
            "Bottom",
            "BottomLeft",
            "BottomRight",
            "BottomCenter",
            "Left",
            "CenterLeft",
            "Right",
            "CenterRight",
            "Center"
        ]
        
//        var pickerConfig = CXPickerConfig()
//        pickerConfig.accessoryType = .checkmark
//        pickerConfig.popupConfig.layoutStyle = .bottomLeft(size: CGSize(width: 160, height: 300))
//        pickerConfig.popupConfig.layoutInsets = UIEdgeInsets(top: 0, left: 16, bottom: 80, right: 0)
//        pickerConfig.popupConfig.animationTransition = CXAnimationTransition(.up)
//        pickerConfig.popupConfig.maskBackgroundColor = .clear

//        let layoutPicker = CXPicker<String>.Builder(array)
//            .withConfig(pickerConfig)
//            .withDefault(array.firstIndex(of: config.layoutStyle.desc))
//            .withOptionHandler { [weak self] (layoutName) in
//                switch layoutName {
//                case "Top":
//                    self?.config.layoutStyle = CXLayoutStyle.top(height: CustomViewDemoViewController.customViewSize.height)
//                case "TopLeft":
//                    self?.config.layoutStyle = CXLayoutStyle.topLeft(size: CustomViewDemoViewController.customViewSize)
//                case "TopRight":
//                    self?.config.layoutStyle = CXLayoutStyle.topRight(size: CustomViewDemoViewController.customViewSize)
//                case "TopCenter":
//                    self?.config.layoutStyle = CXLayoutStyle.topCenter(size: CustomViewDemoViewController.customViewSize)
//                case "Bottom":
//                    self?.config.layoutStyle = CXLayoutStyle.bottom(height: CustomViewDemoViewController.customViewSize.height)
//                case "BottomLeft":
//                    self?.config.layoutStyle = CXLayoutStyle.bottomLeft(size: CustomViewDemoViewController.customViewSize)
//                case "BottomRight":
//                    self?.config.layoutStyle = CXLayoutStyle.bottomRight(size: CustomViewDemoViewController.customViewSize)
//                case "BottomCenter":
//                    self?.config.layoutStyle = CXLayoutStyle.bottomCenter(size: CustomViewDemoViewController.customViewSize)
//                case "Left":
//                    self?.config.layoutStyle = CXLayoutStyle.left(width: CustomViewDemoViewController.customViewSize.width)
//                case "CenterLeft":
//                    self?.config.layoutStyle = CXLayoutStyle.centerLeft(size: CustomViewDemoViewController.customViewSize)
//                case "Right":
//                    self?.config.layoutStyle = CXLayoutStyle.right(width: CustomViewDemoViewController.customViewSize.width)
//                case "CenterRight":
//                    self?.config.layoutStyle = CXLayoutStyle.centerRight(size: CustomViewDemoViewController.customViewSize)
//                case "Center":
//                    self?.config.layoutStyle = CXLayoutStyle.center(size: CustomViewDemoViewController.customViewSize)
//                default:
//                    break
//                }
//            }
//            .create(on: self)
//        self.present(layoutPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapAnimationBarButtonItem(_ sender: Any) {
        var animationPopupConfig = CXPopupAppearance()
        animationPopupConfig.layoutStyle = .bottomCenter(size: CGSize(width: 320, height: 220))
        animationPopupConfig.layoutInsets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        animationPopupConfig.animationTransition = CXAnimationTransition(.up)
        
        if let animationChooser = Bundle.main.loadNibNamed("AnimationChooser", owner: nil, options: nil)?.first as? AnimationChooser {
            animationChooser.setup(config.animationStyle, config.animationTransition) { [weak self] animationStyle, transition in
                self?.config.animationStyle = animationStyle
                self?.config.animationTransition = transition
            }
            CXPopup.Builder(animationChooser)
                .withAppearance(animationPopupConfig)
                .withDelegate(animationChooser)
                .create()
                .pop(on: self)
        }
    }
    
    
    @IBAction func didTapSafeAreaBarButtonItem(_ sender: Any) {
        let array = [
            "On",
            "Off",
            "Wrap",
        ]

//        var pickerConfig = CXPickerConfig()
//        pickerConfig.accessoryType = .checkmark
//        pickerConfig.popupConfig.layoutStyle = .bottomRight(size: CGSize(width: 150, height: 300))
//        pickerConfig.popupConfig.layoutInsets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 16)
//        pickerConfig.popupConfig.animationTransition = CXAnimationTransition(.up)
//        pickerConfig.popupConfig.maskBackgroundColor = .clear
//
//        let safeAreaPicker = CXPicker<String>.Builder(array)
//            .withConfig(pickerConfig)
//            .withDefault(array.firstIndex(of: config.safeAreaStyle.desc))
//            .withOptionHandler { [weak self] (safeAreaName) in
//                print("executed")
//                switch safeAreaName {
//                case "On":
//                    self?.config.safeAreaStyle = .on
//                case "Off":
//                    self?.config.safeAreaStyle = .off
//                case "Wrap":
//                    self?.config.safeAreaStyle = .wrap
//                default:
//                    break
//                }
//            }
//            .create(on: self)
//        self.present(safeAreaPicker, animated: true, completion: nil)
    }
}

fileprivate class CustomView: UIView, CXDialog {
}

extension CXLayoutStyle {
    var desc: String {
        switch self {
        case .top:
            return "Top"
        case .topLeft:
            return "TopLeft"
        case .topRight:
            return "TopRight"
        case .topCenter:
            return "TopCenter"
        case .bottom:
            return "Bottom"
        case .bottomLeft:
            return "BottomLeft"
        case .bottomRight:
            return "BottomRight"
        case .bottomCenter:
            return "BottomCenter"
        case .left:
            return "Left"
        case .centerLeft:
            return "CenterLeft"
        case .right:
            return "Right"
        case .centerRight:
            return "CenterRight"
        case .center:
            return "Center"
        case .custom:
            return "Custom"
        }
    }
}

extension CXSafeAreaStyle {
    var desc: String {
        switch self {
        case .on:
            return "On"
        case .off:
            return "Off"
        case .wrap:
            return "Wrap"
        }
    }
}
