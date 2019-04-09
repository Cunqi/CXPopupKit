//
//  CXPicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 1/27/19.
//

import UIKit

public class CXPicker<T: CustomStringConvertible>: CXPopup {
    private let picker: Picker
    init(_ options: [T], _ config: CXPickerConfig, _ defaultIndex: Int?, _ message: String?, _ handler: ((T) -> Void)?, _ configuration: ((UITableView) -> Void)?, _ vc: UIViewController?) {
        picker = Picker(options, config, defaultIndex, message, handler, configuration)
        super.init(picker, config.popupConfig, picker, vc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public class Builder {
        private var options: [T]
        private var defaultIndex: Int?
        private var message: String?
        private var handler: ((T) -> Void)?
        private var configuration: ((UITableView) -> Void)?
        private var config: CXPickerConfig = CXPickerConfig()

        public init(_ options: [T]) {
            self.options = options
        }

        public func withDefault(_ index: Int?) -> Self {
            self.defaultIndex = index
            return self
        }

        public func withMessage(_ message: String) -> Self {
            self.message = message
            return self
        }

        public func withOptionHandler(_ handler: @escaping (T) -> Void) -> Self {
            self.handler = handler
            return self
        }

        public func withConfig(_ config: CXPickerConfig) -> Self {
            self.config = config
            return self
        }

        public func withConfiguration(_ configuration: @escaping (UITableView) -> Void) -> Self {
            self.configuration = configuration
            return self
        }

        public func create(on vc: UIViewController?) -> UIViewController {
            return CXPicker(options, config, defaultIndex, message, handler, configuration, vc)
        }
    }

    class Picker: UIView, CXDialog, UITableViewDataSource, UITableViewDelegate {
        private let config: CXPickerConfig
        private let optionIdentifier = "_optionIdentifier"

        private let options: [T]
        private var message: String?
        private var handler: ((T) -> Void)?
        private var configuration: ((UITableView) -> Void)?

        private let layout = UIStackView()

        private var tableView: UITableView!
        private var selectedIndex: IndexPath?

        init(_ options: [T], _ config: CXPickerConfig, _ defaultIndex: Int?, _ message: String?, _ handler: ((T) -> Void)?, _ configuration: ((UITableView) -> Void)?) {
            self.config = config
            self.options = options
            self.message = message
            self.handler = handler
            super.init(frame: .zero)

            if let index = defaultIndex {
                self.selectedIndex = IndexPath(row: index, section: 0)
            }
            build(config)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func build(_ config: CXPickerConfig) {
            self.backgroundColor = .white
            layout.axis = .vertical
            layout.distribution = .fill

            if let messageLayout = Picker.createMessageLayout(message, config: config) {
                layout.addArrangedSubview(messageLayout)
                layout.spacing = 1.0
                self.backgroundColor = config.separatorColor
            }
            tableView = UITableView(frame: .zero, style: .plain)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.rowHeight = config.optionRowHeight
            tableView.backgroundColor = config.optionBackgroundColor
            tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .top)
            tableView.separatorColor = config.separatorColor
            configuration?(tableView)
            layout.addArrangedSubview(tableView)
            CXLayoutUtil.fill(layout, at: self)
        }

        private static func createMessageLayout(_ message: String?, config: CXPickerConfig) -> UIView? {
            var height: CGFloat = 0
            guard let message = message else {
                return nil
            }
            let label = UILabel()
            label.text = message
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = config.messageFont
            label.textColor = config.messageTextColor
            label.backgroundColor = .clear

            let width = config.popupConfig.layoutStyle.size.width
            let estimatedHeight = CXTextUtil.getTextSize(
                for: message,
                with: CGSize(width: width - CXSpacing.spacing4, height: CGFloat(Double.greatestFiniteMagnitude)),
                font: label.font).height
            height = estimatedHeight + CXSpacing.spacing5

            let layout = UIView()
            layout.backgroundColor = config.messageBackgroundColor
            layout.heightAnchor.constraint(equalToConstant: height).isActive = true

            CXLayoutUtil.fill(label, at: layout, insets: UIEdgeInsets(top: CXSpacing.spacing4, left: CXSpacing.spacing3, bottom: CXSpacing.spacing4, right: CXSpacing.spacing3))
            return layout
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return options.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: optionIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: optionIdentifier)
                cell?.selectionStyle = .default
                cell?.textLabel?.textColor = config.optionTextColor
                cell?.textLabel?.textAlignment = config.optionTextAligment
                cell?.contentView.backgroundColor = config.optionBackgroundColor
            }
            let option = options[indexPath.row]
            cell?.textLabel?.text = option.description

            if let selectedIndex = self.selectedIndex, selectedIndex == indexPath {
                cell?.accessoryType = config.accessoryType
            } else {
                cell?.accessoryType = .none
            }
            return cell!
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Dismisss")
//            self.cxPopup?.dismiss()
        }
    }
}

extension CXPicker.Picker: CXPopupLifeCycleDelegate {
    public func viewDidDisappear() {
        if let indexPath = tableView.indexPathForSelectedRow {
            let option = options[indexPath.row]
            handler?(option)
        }
    }
}

public struct CXPickerConfig {
    public var popupConfig = CXPopupConfig()

    public var accessoryType = UITableViewCell.AccessoryType.none
    public var messageFont = UIFont.systemFont(ofSize: 14.0)
    public var messageTextColor = UIColor.darkGray
    public var messageBackgroundColor = UIColor.white
    public var separatorColor = UIColor(white: 0.85, alpha: 1.0)
    public var optionRowHeight: CGFloat = 44.0
    public var optionTextColor = UIColor.black
    public var optionTextAligment = NSTextAlignment.left
    public var optionBackgroundColor = UIColor.white

    public init() {}
}
