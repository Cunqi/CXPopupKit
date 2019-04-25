//
//  CXListPicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/16/19.
//

import UIKit

public class CXListPicker<T: CustomStringConvertible>: CXBasePicker, CXItemSelectable, UITableViewDataSource, UITableViewDelegate {
    public typealias Item = T

    public var handler: ((T) -> Void)?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    var items: [T]? {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedItem: T?

    private let cellIdentifier = "_CXListPickerItemIdentifier"
    private let standardRowHeight: CGFloat = 44
    private let preferredHeight = CXLayoutStyle.screen.size.height.quarter

    public convenience init(items: [T], selectedItem: T?, popupAppearance: CXPopupAppearance) {
        self.init(items: items, selectedItem: selectedItem, popupAppearance: popupAppearance, handler: nil)
    }

    public init(items: [T], selectedItem: T?, popupAppearance: CXPopupAppearance, handler: ((T) -> Void)?) {
        self.items = items
        self.selectedItem = selectedItem
        self.handler = handler
        super.init(popupAppearance)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK - CXPopupLifecycleDelegate
    public override func finalizeLayoutStyleBeforeInstallConstraints(_ current: CXPopupAppearance, _ submit: (CXLayoutStyle) -> Void) {
        let height = min(preferredHeight, standardRowHeight * CGFloat(items?.count ?? 0))
        let size = CGSize(width: CXLayoutStyle.screen.size.width, height: height)
        let layoutStyle = current.layoutStyle.update(size: size)
        submit(layoutStyle)
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
            cell?.backgroundColor = pickerAppearance.backgroundColor
        }
        let item = items?[indexPath.row]
        cell?.textLabel?.text = item?.description
        cell?.accessoryType = item?.description == selectedItem?.description ? .checkmark : .none
        return cell ?? UITableViewCell()
    }

    // MARK - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return standardRowHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = items?[indexPath.row]
        self.popupController?.commit()
    }

    override func layout() {
        CXLayoutBuilder.fill(tableView, self, .zero)
    }

    override func dismiss(for type: CXDismissType) {
        guard type == .confirm, let item = selectedItem else {
            return
        }
        handler?(item)
    }
}
