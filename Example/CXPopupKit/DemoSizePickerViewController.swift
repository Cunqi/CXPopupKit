//
//  DemoSizePickerViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi Xiao on 3/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import SnapKit
import UIKit

class DemoSizePickerViewController: UIViewController, CXPopupControlDelegate {
    var picker: UIPickerView!
    var widthLabel: UILabel!
    var heightLabel: UILabel!
    let itemsForFirstComponent = CXEdge.items
    let itemsForSecondComponent = CXEdge.items

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Size"

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
        widthLabel.text = "Width"
        widthLabel.textAlignment = .center

        heightLabel.snp.makeConstraints { maker in
            maker.trailing.equalTo(picker.snp.trailing)
            maker.top.bottom.width.equalTo(widthLabel)
        }
        heightLabel.text = "Height"
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

extension DemoSizePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension CXEdge {
    static var items: [CXEdge] {
        return [.full, .ratio(0.8), .fixed(240)]
    }

    var desc: String {
        switch self {
            case .full:
                return "Full"
            case .ratio(_):
                return "Ratio(0.8)"
            case .fixed(_):
                return "Fixed(240)"
        }
    }

    static func value(from index: Int) -> CXEdge {
        if index == 0 {
            return .full
        } else if index == 1 {
            return .ratio(0.8)
        }
        return .fixed(240)
    }
}
