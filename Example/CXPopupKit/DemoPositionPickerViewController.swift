//
//  DemoPositionPickerViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 3/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import SnapKit
import UIKit

class DemoPositionPickerViewController: UIViewController, CXPopupControlDelegate {
    var picker: UIPickerView!
    var horizontalLabel: UILabel!
    var verticalLabel: UILabel!
    let itemsForFirstComponent = CXAxisX.items
    let itemsForSecondComponent = CXAxisY.items

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Position"

        horizontalLabel = UILabel()
        verticalLabel = UILabel()

        picker = UIPickerView()
        view.addSubview(picker)
        picker.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview().inset(4)
        }
        picker.dataSource = self
        picker.delegate = self

        view.addSubview(horizontalLabel)
        view.addSubview(verticalLabel)

        horizontalLabel.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.topMargin)
            maker.leading.equalTo(picker)
            maker.height.equalTo(44)
            maker.bottom.equalTo(picker.snp.top)
            maker.width.equalTo(picker.snp.width).multipliedBy(0.5)
        }
        horizontalLabel.text = "Horizontal"
        horizontalLabel.textAlignment = .center

        verticalLabel.snp.makeConstraints { maker in
            maker.trailing.equalTo(picker.snp.trailing)
            maker.top.bottom.width.equalTo(horizontalLabel)
        }
        verticalLabel.text = "Vertical"
        verticalLabel.textAlignment = .center

        let applyBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(didTapApplyBarButtonItem))
        navigationItem.rightBarButtonItem = applyBarButtonItem
    }

    var wrapped: DemoNavigationController {
        DemoNavigationController(rootViewController: self)
    }

    @objc
    private func didTapApplyBarButtonItem() {
        popup?.dismiss(animated: true, completion: nil)
    }
}

extension DemoPositionPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
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

extension CXAxisX {
    static var items: [CXAxisX] {
        [.left, .center, .right ]
    }

    var desc: String {
        switch self {
            case .left:
                return "Left"
            case .center:
                return "Center"
            case .right:
                return "Right"
        case .custom:
            fallthrough
        @unknown default:
            return ""
        }
    }

    static func value(from index: Int) -> CXAxisX {
        if index == 0 {
            return .left
        } else if index == 1 {
            return .center
        }
        return .right
    }
}

extension CXAxisY {
    static var items: [CXAxisY] {
        [.top, .center, .bottom ]
    }

    var desc: String {
        switch self {
        case .top:
            return "Top"
        case .center:
            return "Center"
        case .bottom:
            return "Bottom"
        case .custom:
            fallthrough
        @unknown default:
            return ""
        }
    }

    static func value(from index: Int) -> CXAxisY {
        if index == 0 {
            return .top
        } else if index == 1 {
            return .center
        }
        return .bottom
    }
}
