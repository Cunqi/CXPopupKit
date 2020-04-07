//
//  DemoAnimationTransitionPickerViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 3/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import SnapKit
import UIKit

class DemoAnimationTransitionPickerViewController: UIViewController, CXPopupControlDelegate {
    var picker: UIPickerView!
    var widthLabel: UILabel!
    var heightLabel: UILabel!
    let itemsForFirstComponent = CXAnimationDirection.items
    let itemsForSecondComponent = CXAnimationDirection.items

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Transition"

        widthLabel = UILabel()
        heightLabel = UILabel()

        picker = UIPickerView()
        view.addSubview(picker)
        picker.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview().inset(4)
        }
        picker.dataSource = self
        picker.delegate = self

        view.addSubview(widthLabel)
        view.addSubview(heightLabel)

        widthLabel.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.topMargin)
            maker.leading.equalTo(picker)
            maker.height.equalTo(44)
            maker.bottom.equalTo(picker.snp.top)
            maker.width.equalTo(picker.snp.width).multipliedBy(0.5)
        }
        widthLabel.text = "In"
        widthLabel.textAlignment = .center

        heightLabel.snp.makeConstraints { maker in
            maker.trailing.equalTo(picker.snp.trailing)
            maker.top.bottom.width.equalTo(widthLabel)
        }
        heightLabel.text = "Out"
        heightLabel.textAlignment = .center

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

extension DemoAnimationTransitionPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return itemsForFirstComponent.count
        }
        return itemsForSecondComponent.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return itemsForFirstComponent[row].desc
        }
        return itemsForSecondComponent[row].desc
    }
}

extension CXAnimationDirection {
    static var items: [CXAnimationDirection] {
        return [.left, .up, .center , .down, .right]
    }

    var desc: String {
        switch self {
        case .left:
            return "Left"
        case .right:
            return "Right"
        case .center:
            return "Center"
        case .up:
            return "Up"
        case .down:
            return "Down"
        }
    }

    static func value(from index: Int) -> CXAnimationDirection {
        if index == 0 {
            return .left
        } else if index == 1 {
            return .up
        } else if index == 2 {
            return .center
        } else if index == 3 {
            return .down
        }
        return .right
    }
}
