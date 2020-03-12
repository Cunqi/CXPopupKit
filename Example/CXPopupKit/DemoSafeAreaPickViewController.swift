//
//  DemoSafeAreaPickViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi Xiao on 3/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import SnapKit
import UIKit

class DemoSafeAreaPickViewController: UIViewController, CXPopupControlDelegate {
    var picker: UIPickerView!
    let items = CXSafeAreaPolicy.items

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Safe Area"

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
        print(self.parent)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension DemoSafeAreaPickViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension CXSafeAreaPolicy {
    static var items: [CXSafeAreaPolicy] {
        return [.system, .auto, .disable]
    }

    var desc: String {
        switch self {
            case .system:
                return "System"
            case .auto:
                return "Auto"
            case .disable:
                return "Disable"
        }
    }
}
