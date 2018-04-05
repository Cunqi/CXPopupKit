//
//  DemoListViewController.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 3/13/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXPopupKit

class DemoListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let items: [DemoItem] = [.basic, .roundedCorner, .slideMenu, .slideMenuWithSafeArea, .actionSheet, .basicSampleWithSafeAreaInside, .basicSampleWithoutSafeAreaButPadding, .alertView, .singleStringPicker, .singleCustomPicker, .datePicker]
    private let cellIdentifier = "DemoItem"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Demo List"
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension DemoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
}

extension DemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
        case .basic:
            showBasicPopup()
        case .roundedCorner:
            showRoundedCornerPopup()
        case .slideMenu:
            showSlideMenuPopup()
        case .slideMenuWithSafeArea:
            showSlideMenuWithSafeAreaPopup()
        case .actionSheet:
            showActionSheetPopup()
        case .basicSampleWithSafeAreaInside:
            showBasicSampleWithSafeAreaInsidePopup()
        case .basicSampleWithoutSafeAreaButPadding:
            showBasicSampleWithoutSafeAreaButPadding()
        case .alertView:
            showAlertViewPopup()
        case .singleStringPicker:
            showSingleStringPicker()
        case .singleCustomPicker:
            showSingleCustomPicker()
        case .datePicker:
            showDatetimePicker()
        }
    }

    private func showBasicPopup() {
        let basicSample = BasicSample()
        let popup = basicSample.createPopup()
        popup.appearance.uiStyle.popupBackgroundColor = .white
        popup.appearance.dimension.width = .fixValue(size: 300)
        popup.appearance.dimension.height = .percentageOfParent(ratio: 0.35)
        popup.appearance.animation.style = .bounceZoom
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showRoundedCornerPopup() {
        let basicSample = BasicSample()
        basicSample.backgroundColor = .white
        basicSample.layer.cornerRadius = 9.0
        basicSample.layer.masksToBounds = true
        let popup = basicSample.createPopup()
        popup.appearance.uiStyle.popupBackgroundColor = .white
        popup.appearance.dimension.width = .fixValue(size: 300)
        popup.appearance.dimension.height = .percentageOfParent(ratio: 0.35)
        popup.appearance.dimension.position = .center
        popup.appearance.animation.style = .bounceZoom
        popup.appearance.orientation.isAutoRotationEnabled = true

        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showSlideMenuPopup() {
        let menuSample = MenuSample()
        menuSample.backgroundColor = .white

        let popup = menuSample.createPopup()
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showSlideMenuWithSafeAreaPopup() {
        let menuSample = MenuSample()
        menuSample.backgroundColor = .white

        let popup = menuSample.createPopup()
        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showActionSheetPopup() {
//        let actionSheet = CXAlertView(type: .actionSheet, title: nil, message: "Pick a photo from library", cancel: "cancel", actions: ["OK"])
//        DispatchQueue.main.async {
//            actionSheet.show(at: self)
//        }
    }

    private func showAlertViewPopup() {
//        let actionSheet = CXAlertView(type: .alert, title: nil, message: "Pick a photo from library", cancel: "cancel", actions: ["OK"])
//        DispatchQueue.main.async {
//            actionSheet.show(at: self)
//        }
    }

    private func showBasicSampleWithSafeAreaInsidePopup() {
        let basicSample = BasicSample()
        basicSample.layer.cornerRadius = 32.0
        basicSample.layer.masksToBounds = true
        basicSample.backgroundColor = .red
        let popup = basicSample.createPopup()

        popup.appearance.uiStyle.popupBackgroundColor = .clear
        popup.appearance.dimension.width = .matchPartent
        popup.appearance.dimension.height = .fixValue(size: 300)
        popup.appearance.dimension.position = .bottom
        popup.appearance.dimension.safeAreaOption = .normal
        popup.appearance.animation.style = .fade
        popup.appearance.orientation.isAutoRotationEnabled = true

        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showBasicSampleWithoutSafeAreaButPadding() {
        let basicSample = BasicSample()
        basicSample.layer.cornerRadius = 32.0
        basicSample.layer.masksToBounds = true
        basicSample.backgroundColor = .red

        let popup = basicSample.createPopup()
        popup.appearance.dimension.width = .matchPartent
        popup.appearance.dimension.height = .fixValue(size: 300)
        popup.appearance.dimension.position = .bottom
        popup.appearance.dimension.safeAreaOption = .insidePopup
        popup.appearance.animation.style = .fade
        popup.appearance.orientation.isAutoRotationEnabled = true

        DispatchQueue.main.async {
            popup.show(at: self)
        }
    }

    private func showSingleStringPicker() {
//        let picker = CXPicker(with: ["Yes", "No", "I don't think so"], title: "isGoodEnough", cancelButtonText: "Cancel", doneButtonText: "Done")
//        DispatchQueue.main.async {
//            picker.createPopup().show(at: self)
//        }
    }

    private func showSingleCustomPicker() {
//        let personA = Person(name: "Jack", age: 23)
//        let personB = Person(name: "Rose", age: 22)
//        let personC = Person(name: "Pi", age: 18)
//        let picker = CXPicker(with: [personA, personB, personC], title: "Character", cancelButtonText: "Cancel", doneButtonText: "Done")
//        let popup = picker.createPopup()
//        popup.positiveAction = { result in
//            guard let person = result as? Person else {
//                return
//            }
//            print(person.age)
//        }
//        DispatchQueue.main.async {
//            popup.show(at: self)
//        }
    }

    private func showDatetimePicker() {
//        let picker = CXDatePicker(startDate: nil, mode: .dateAndTime, title: "Start Date", cancelButtonText: "Cancel", doneButtonText: "Done")
//        let popup = picker.createPopup()
//        popup.positiveAction = { result in
//            guard let date = result as? Date else {
//                return
//            }
//            print(date)
//        }
//        DispatchQueue.main.async {
//            popup.show(at: self)
//        }
    }
}

enum DemoItem {
    case basic
    case roundedCorner
    case slideMenu
    case slideMenuWithSafeArea
    case actionSheet
    case basicSampleWithSafeAreaInside
    case basicSampleWithoutSafeAreaButPadding
    case alertView
    case singleStringPicker
    case singleCustomPicker
    case datePicker

    var title: String {
        switch self {
        case .basic:
            return "Basic + (Plain Animation)"
        case .roundedCorner:
            return "Rounded corner + (Bounce zoom animation)"
        case .slideMenu:
            return "Slide menu (disable safe area)"
        case .slideMenuWithSafeArea:
            return "Slide menu (enable safe area)"
        case .actionSheet:
            return "Action sheet"
        case .basicSampleWithSafeAreaInside:
            return "Basic + (Safe area inside)"
        case .basicSampleWithoutSafeAreaButPadding:
            return "Basic + (Padding, no safe area)"
        case .alertView:
            return "Alert View"
        case .singleStringPicker:
            return "Single String Picker"
        case .singleCustomPicker:
            return "Single Custom Picker"
        case .datePicker:
            return "Date Picker"
        }
    }
}
