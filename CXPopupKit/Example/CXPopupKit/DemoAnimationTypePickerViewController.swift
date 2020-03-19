//
//  DemoAnimationTypePickerViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 3/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import SnapKit
import UIKit

class DemoAnimationTypePickerViewController: UIViewController, CXPopupControlDelegate {
    var picker: UIPickerView!
    let items = CXAnimationType.items

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Animation Type"

        picker = UIPickerView()
        view.addSubview(picker)
        picker.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(4)
        }
        picker.dataSource = self
        picker.delegate = self

        let applyBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(didTapApplyBarButtonItem))
        navigationItem.rightBarButtonItem = applyBarButtonItem
    }

    var wrapped: DemoNavigationController {
        return DemoNavigationController(rootViewController: self)
    }

    @objc
    private func didTapApplyBarButtonItem() {
        popup?.dismiss(animated: true, completion: nil)
    }
}

extension DemoAnimationTypePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].desc
    }
}

extension CXAnimationType {
    static var items: [CXAnimationType] {
        return [.basic, .fade, .bounce, .zoom, .pop]
    }
    
    var desc: String {
        switch self {
        case .basic:
            return "Basic"
        case .fade:
            return "Fade"
        case .bounce:
            return "Bounce"
        case .zoom:
            return "Zoom"
        case .pop:
            return "Pop"
        case .custom:
            fallthrough
        @unknown default:
            return ""
        }
    }
    
    static func value(for index: Int) -> CXAnimationType {
        if index == 0 {
            return .basic
        } else if index == 1 {
            return .fade
        } else if index == 2 {
            return .bounce
        } else if index == 3 {
            return .zoom
        } else if index == 4 {
            return .pop
        }
        return .basic
    }
}

