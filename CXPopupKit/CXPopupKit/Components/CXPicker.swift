//
//  CXPicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/28/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public class CXPickerBuilder<T: CustomStringConvertible> {
    let popupBuilder: CXPopupBuilder
    let cxPicker: CXPicker<T>
    var popupAppearance: CXPopupAppearance = {
        var appearance = CXPopupAppearance()
        appearance.height = .part(ratio: 0.33)
        appearance.position = CXPosition(horizontal: .center, vertical: .bottom)
        appearance.safeAreaType = .wrapped
        appearance.shouldDismissOnBackgroundTap = true
        appearance.backgroundColor = .white
        appearance.animationTransition = CXAnimationTransition(in: .up)
        return appearance
    }()

    public init(title: String?, at presenting: UIViewController?) {
        self.cxPicker = CXPicker<T>(title: title)
        self.popupBuilder = CXPopupBuilder(content: self.cxPicker, presenting: presenting)
    }

    public func withSimpleData(_ data: [T]) -> Self {
        cxPicker.pickerAdapter = CXPickerAdapter<T>(simple: data)
        cxPicker.dataType = .simple
        return self
    }

    public func withComplexData(_ data: [[T]]) -> Self {
        cxPicker.pickerAdapter = CXPickerAdapter<T>(complex: data)
        cxPicker.dataType = .complex
        return self
    }

    public func withSimpleDataSelected(_ action: @escaping (T) -> Void) -> Self {
        cxPicker.simpleDataSelectedAction = action
        return self
    }

    public func withComplexDataSelected(_ action: @escaping ([T]) -> Void) -> Self {
        cxPicker.complexDataSelectedAction = action
        return self
    }

    public func withSelectionConfirmed(_ action: @escaping (UIPickerView) -> Void) -> Self {
        cxPicker.selectionConfirmedAction = action
        return self
    }

    public func withDataSource(_ dataSource: UIPickerViewDataSource) -> Self {
        cxPicker.picker.dataSource = dataSource
        return self
    }

    public func withDelegate(_ delegate: UIPickerViewDelegate) -> Self {
        cxPicker.picker.delegate = delegate
        return self
    }

    public func withNavigationBarConfiguration(_ configuration: @escaping (UINavigationBar) -> Void) -> Self {
        cxPicker.navigationBarConfiguration = configuration
        return self
    }

    public func build() -> CXPopupWindow & UIViewController {
        return popupBuilder.withAppearance(popupAppearance).build()
    }
}

public struct CXPickerAppearance {
}

class CXPicker<T: CustomStringConvertible>: UIView, CXPopupable {
    let picker: UIPickerView
    let pickerNavigationBar: UINavigationBar

    let navigationBarHeight: CGFloat = 44

    var pickerAdapter: CXPickerAdapter<T>? {
        didSet {
            self.picker.dataSource = pickerAdapter
            self.picker.delegate = pickerAdapter
        }
    }

    var dataType: CXPickerDataType = .custom
    var selectionConfirmedAction: ((UIPickerView) -> Void)?
    var simpleDataSelectedAction: ((T) -> Void)?
    var complexDataSelectedAction: (([T]) -> Void)?
    var navigationBarConfiguration: ((UINavigationBar) -> Void)?

    init(title: String?) {
        self.picker = UIPickerView(frame: .zero)
        self.pickerNavigationBar = UINavigationBar(frame: .zero)
        super.init(frame: .zero)

        setupNavigationBar(title)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        self.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: self.pickerNavigationBar.bottomAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    @objc func didTapCancelButton() {
        popupWindow?.close()
    }

    @objc func didTapDoneButton() {
        switch dataType {
        case .simple:
            handleSimpleDataSelectedAction()
        case .complex:
            handleComplexDataSelectedAction()
        case .custom:
            handleCustomDataSelectedAction()
        }
    }

    private func handleSimpleDataSelectedAction() {
        let row = picker.selectedRow(inComponent: 0)
        if let data = pickerAdapter?.getSelectedSimpleData(at: row) {
            self.simpleDataSelectedAction?(data)
        }
        popupWindow?.close()
    }

    private func handleComplexDataSelectedAction() {
        let components = picker.numberOfComponents
        var result = [T]()
        for component in 0 ..< components {
            let row = picker.selectedRow(inComponent: component)
            if let data = pickerAdapter?.getSelectedComplexData(for: component, at: row) {
                result.append(data)
            }
        }
        complexDataSelectedAction?(result)
        popupWindow?.close()
    }

    private func handleCustomDataSelectedAction() {
        selectionConfirmedAction?(self.picker)
        popupWindow?.close()
    }
}

class CXPickerAdapter<T: CustomStringConvertible>: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let rowHeight: CGFloat = 44
    let simple: [T]?
    let complex: [[T]]?

    init(simple: [T]) {
        self.simple = simple
        self.complex = nil
        super.init()
    }

    init(complex: [[T]]) {
        self.complex = complex
        self.simple = nil
        super.init()
    }

    var pickerDataType: CXPickerDataType {
        return simple != nil ? .simple : (complex != nil ? .complex : .custom)
    }

    func getSelectedSimpleData(at row: Int) -> T? {
        return simple?[row]
    }

    func getSelectedComplexData(for component: Int, at row: Int) -> T? {
        return complex?[component][row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return complex?.count ?? (simple == nil ? 0 : 1)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let complex = complex {
            return complex[component].count
        } else if let simple = simple {
            return simple.count
        } else {
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let complex = complex {
            let rowAtComponent = complex[component]
            return rowAtComponent[row].description
        } else if let simple = simple {
            return simple[row].description
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
}

enum CXPickerDataType {
    case simple
    case complex
    case custom
}
