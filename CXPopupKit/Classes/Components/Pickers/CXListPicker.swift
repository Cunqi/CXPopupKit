//
//  CXListPicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/16/19.
//

import UIKit

public class CXListPicker<T: CustomStringConvertible>: UIView, CXDialog, UITableViewDataSource, UITableViewDelegate {
    struct ListPickerAppearance {
        var font = UIFont.systemFont(ofSize: 13.0)
        var textAlignment = NSTextAlignment.natural
        var rowHeight: CGFloat = 44.0
        var textColor = UIColor.black
        var backgroundColor: UIColor? = UIColor.white
        init(){}
    }

    @objc public dynamic var font: UIFont {
        get {return pickerAppearance.font }
        set {pickerAppearance.font = newValue }
    }

    @objc public dynamic var textColor: UIColor {
        get { return pickerAppearance.textColor }
        set { pickerAppearance.textColor = newValue }
    }

    @objc public dynamic var textAlignment: NSTextAlignment {
        get { return pickerAppearance.textAlignment }
        set { pickerAppearance.textAlignment = newValue }
    }

    @objc public dynamic override var backgroundColor: UIColor? {
        get { return pickerAppearance.backgroundColor }
        set { pickerAppearance.backgroundColor = newValue
              popupAppearance.popupBackgroundColor = newValue }
    }

    @objc public dynamic var rowHeight: CGFloat {
        get { return pickerAppearance.rowHeight }
        set { pickerAppearance.rowHeight = newValue }
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    var popupAppearance: CXPopupAppearance
    var pickerAppearance = ListPickerAppearance()

    var items: [T]? {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedItem: T?
    var handler: ((T) -> Void)?

    private let cellIdentifier = "_CXListPickerItemIdentifier"

    public init(items: [T], selectedItem: T?, appearance: CXPopupAppearance, handler: ((T) -> Void)?) {
        self.items = items
        self.selectedItem = selectedItem
        self.handler = handler
        self.popupAppearance = appearance
        super.init(frame: .zero)

        // Sync appearances
        self.popupAppearance.popupBackgroundColor = pickerAppearance.backgroundColor

        let height = min(300, pickerAppearance.rowHeight * CGFloat(items.count))
        let size = CGSize(width: UIScreen.main.bounds.width, height: height)
        self.popupAppearance.layoutStyle.update(size: size)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.selectionStyle = .default
            cell?.textLabel?.font = pickerAppearance.font
            cell?.textLabel?.textColor = pickerAppearance.textColor
            cell?.textLabel?.textAlignment = pickerAppearance.textAlignment
        }
        let item = items?[indexPath.row]
        cell?.textLabel?.text = item?.description
        cell?.accessoryType = item?.description == selectedItem?.description ? .checkmark : .none
        return cell ?? UITableViewCell()
    }

    // MARK - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return pickerAppearance.rowHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = items?[indexPath.row]
        self.popupController?.commit()
    }
}

extension CXListPicker: CXPopupable {
    public func pop(on vc: UIViewController?) {
        CXPopupController(self, appearance: self.popupAppearance, self).pop(on: vc)
    }
}

extension CXListPicker: CXPopupLifecycleDelegate {
    public func viewDidLoad() {
        CXLayoutBuilder.fill(tableView, self, .zero)
    }

    public func viewDidDisappear(_ dismissType: CXDismissType) {
        guard dismissType == .confirm, let item = selectedItem else {
            return
        }
        handler?(item)
    }
}
