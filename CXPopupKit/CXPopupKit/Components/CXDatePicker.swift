//
//  CXDatePicker.swift
//  CXPopupKit
//
//  Created by Cunqi on 8/29/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public class CXDatePickerBuilder {
    let cxDatePicker: CXDatePicker
    let popupBuilder: CXPopupBuilder

    var popupAppearance: CXPopupAppearance = {
        var appearance = CXPopupAppearance()
        appearance.height = .part(ratio: 0.33)
        appearance.position = CXPosition(horizontal: .center, vertical: .bottom)
        appearance.safeAreaType = .wrapped
        appearance.allOutsideDismiss = true
        appearance.backgroundColor = .white
        appearance.animationTransition = CXAnimationTransition(in: .up)
        return appearance
    }()

    public init(title: String?, at presenting: UIViewController?) {
        self.cxDatePicker = CXDatePicker(title: title)
        self.popupBuilder = CXPopupBuilder(content: cxDatePicker, presenting: presenting)
    }

    public func withDateTimeSelected(_ action: @escaping (Date) -> Void) -> Self {
        self.cxDatePicker.datetimeSelectedAction = action
        return self
    }

    public func withNavigationBarConfiguration(_ configuration: @escaping (UINavigationBar) -> Void) -> Self {
        cxDatePicker.navigationBarConfiguration = configuration
        return self
    }

    public func withDatePickerConfiguration(_ configuration: @escaping  (UIDatePicker) -> Void) -> Self {
        cxDatePicker.datePickerConfiguration = configuration
        return self
    }

    public func withStartDate(_ date: Date) -> Self {
        self.cxDatePicker.datePicker.date = date
        return self
    }

    public func build() -> CXPopupWindow & UIViewController {
        return popupBuilder.withAppearance(popupAppearance).build()
    }
}

class CXDatePicker: UIView, CXPopupable {
    let navigationBarHeight: CGFloat = 44
    let datePicker: UIDatePicker
    let pickerNavigationBar: UINavigationBar
    var navigationBarConfiguration: ((UINavigationBar) -> Void)?
    var datePickerConfiguration: ((UIDatePicker) -> Void)?
    var datetimeSelectedAction: ((Date) -> Void)?

    init(title: String?) {
        self.datePicker = UIDatePicker()
        self.pickerNavigationBar = UINavigationBar(frame: .zero)
        super.init(frame: .zero)
        setupDatePicker()
        setupNavigationBar(title)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePickerConfiguration?(datePicker)
    }

    func setupNavigationBar(_ title: String?) {
        let navigationItem = UINavigationItem()
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.title = title
        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: false)
        navigationItem.setRightBarButton(doneBarButtonItem, animated: false)
        pickerNavigationBar.pushItem(navigationItem, animated: false)
        navigationBarConfiguration?(pickerNavigationBar)
    }

    func setupLayout() {
        self.addSubview(pickerNavigationBar)
        pickerNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        pickerNavigationBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        pickerNavigationBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        pickerNavigationBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pickerNavigationBar.heightAnchor.constraint(equalToConstant: navigationBarHeight).isActive = true

        self.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: self.pickerNavigationBar.bottomAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    @objc func didTapCancelButton() {
        popupWindow?.close()
    }

    @objc func didTapDoneButton() {
        datetimeSelectedAction?(datePicker.date)
        popupWindow?.close()
    }
}
