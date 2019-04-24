//
//  AnimationChooser.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 1/29/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CXPopupKit

class AnimationChooser: UIView, CXDialog {
    @IBOutlet private weak var inAnimationButton: UIButton!
    @IBOutlet private weak var outAnimationButton: UIButton!
    @IBOutlet private weak var animationStyleButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    
    private var animationStyle: CXAnimationStyle = .basic
    private var inDirection: CXAnimationDirection = .up
    private var outDirection: CXAnimationDirection = .down
    private var handler: ((CXAnimationStyle, CXAnimationTransition) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inAnimationButton.addTarget(self, action: #selector(didTapInAnimationButton), for: .touchUpInside)
        outAnimationButton.addTarget(self, action: #selector(didTapOutAnimationButton), for: .touchUpInside)
        animationStyleButton.addTarget(self, action: #selector(didTapAnimationStyleButton), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(didTapApplyButton), for: .touchUpInside)
    }
    
    func setup(_ animationStyle: CXAnimationStyle, _ transition: CXAnimationTransition, _ handler: @escaping (CXAnimationStyle, CXAnimationTransition) -> Void) {
        self.animationStyle = animationStyle
        self.inDirection = transition.in
        self.outDirection = transition.out
        self.animationStyleButton.setTitle(animationStyle.desc, for: .normal)
        self.inAnimationButton.setTitle(inDirection.desc, for: .normal)
        self.outAnimationButton.setTitle(outDirection.desc, for: .normal)
        self.handler = handler
    }
    
    @objc private func didTapInAnimationButton() {
        let array = [
            "Up",
            "Down",
            "Left",
            "Right",
            "Center"
        ]

//        var pickerConfig = CXPickerConfig()
//        pickerConfig.accessoryType = .checkmark
//        pickerConfig.popupConfig.layoutStyle = .top(height: 220)
//        pickerConfig.popupConfig.animationTransition = CXAnimationTransition(.down)
//        pickerConfig.popupConfig.maskBackgroundColor = .clear
//        pickerConfig.popupConfig.safeAreaStyle = .wrap
//
//        let directionPicker = CXPicker<String>.Builder(array)
//            .withConfig(pickerConfig)
//            .withDefault(array.firstIndex(of: self.inDirection.desc))
//            .withOptionHandler { [weak self] (directionName) in
//                self?.inAnimationButton.setTitle(directionName, for: .normal)
//                switch directionName {
//                case "Up":
//                    self?.inDirection = .up
//                case "Down":
//                    self?.inDirection = .down
//                case "Left":
//                    self?.inDirection = .left
//                case "Right":
//                    self?.inDirection = .right
//                case "Center":
//                    self?.inDirection = .center
//                default:
//                    break
//                }
//            }
//            .create(on: self.cxPopup)
//        self.cxPopup?.present(directionPicker, animated: true, completion: nil)
    }
    
    @objc private func didTapOutAnimationButton() {
        let array = [
            "Up",
            "Down",
            "Left",
            "Right",
            "Center"
        ]

//        var pickerConfig = CXPickerConfig()
//        pickerConfig.accessoryType = .checkmark
//        pickerConfig.popupConfig.layoutStyle = .top(height: 220)
//        pickerConfig.popupConfig.animationTransition = CXAnimationTransition(.down)
//        pickerConfig.popupConfig.maskBackgroundColor = .clear
//        pickerConfig.popupConfig.safeAreaStyle = .wrap
//
//        let directionPicker = CXPicker<String>.Builder(array)
//            .withConfig(pickerConfig)
//            .withDefault(array.firstIndex(of: self.outDirection.desc))
//            .withOptionHandler { [weak self] (directionName) in
//                self?.outAnimationButton.setTitle(directionName, for: .normal)
//                switch directionName {
//                case "Up":
//                    self?.outDirection = .up
//                case "Down":
//                    self?.outDirection = .down
//                case "Left":
//                    self?.outDirection = .left
//                case "Right":
//                    self?.outDirection = .right
//                case "Center":
//                    self?.outDirection = .center
//                default:
//                    break
//                }
//            }
//            .create(on: self.cxPopup)
//        self.cxPopup?.present(directionPicker, animated: true, completion: nil)
    }
    
    @objc private func didTapAnimationStyleButton() {
        let array = [
            "Basic",
            "Fade",
            "Bounce",
            "Zoom",
            "Pop"
        ]
        
//        var pickerConfig = CXPickerConfig()
//        pickerConfig.accessoryType = .checkmark
//        pickerConfig.popupConfig.layoutStyle = .top(height: 220)
//        pickerConfig.popupConfig.animationTransition = CXAnimationTransition(.down)
//        pickerConfig.popupConfig.maskBackgroundColor = .clear
//        pickerConfig.popupConfig.safeAreaStyle = .wrap
//        
//        let animationPicker = CXPicker<String>.Builder(array)
//            .withConfig(pickerConfig)
//            .withDefault(array.firstIndex(of: self.animationStyle.desc))
//            .withOptionHandler { [weak self] (animationName) in
//                self?.animationStyleButton.setTitle(animationName, for: .normal)
//                switch animationName {
//                case "Basic":
//                    self?.animationStyle = .basic
//                case "Fade":
//                    self?.animationStyle = .fade
//                case "Bounce":
//                    self?.animationStyle = .bounce
//                case "Zoom":
//                    self?.animationStyle = .zoom
//                case "Pop":
//                    self?.animationStyle = .pop
//                default:
//                    break
//                }
//            }
//            .create(on: self.cxPopup)
//        self.cxPopup?.present(animationPicker, animated: true, completion: nil)
    }
    
    @objc private func didTapApplyButton() {
        self.cxPopup?.dismiss()
    }
}

extension AnimationChooser: CXPopupLifecycleDelegate {
    func viewDidDisappear() {
        let transition = CXAnimationTransition(inDirection, outDirection)
        handler?(animationStyle, transition)
    }
}

extension CXAnimationStyle {
    var desc: String {
        switch self {
        case .basic:
            return "Basic"
        case .bounce:
            return "Bounce"
        case .fade:
            return "Fade"
        case .pop:
            return "Pop"
        case .zoom:
            return "Zoom"
        case .custom:
            return "Custom"
        }
    }
}

extension CXAnimationDirection {
    var desc: String {
        switch self {
        case .up:
            return "Up"
        case .down:
            return "Down"
        case .left:
            return "Left"
        case .right:
            return "Right"
        case .center:
            return "Center"
        }
    }
}
