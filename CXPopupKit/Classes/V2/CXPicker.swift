//
//  CXPicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 1/27/19.
//

import UIKit

public protocol CXPickable {
    func getOptionText() -> String
}

public class CXPicker<T: CXPickable>: CXPopup {
    init(_ options: [T], _ config: CXPopupConfig, _ defaultValue: T?, _ message: String?, _ handler: ((T) -> Void)?, _ vc: UIViewController?) {
        let picker = Picker(options, config, defaultValue, message, handler)
        super.init(picker, config, picker, vc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public class Builder {
        private var options: [T]
        private var defaultValue: T?
        private var message: String?
        private var handler: ((T) -> Void)?
        private var config: CXPopupConfig = CXPopupConfig()

        public init(_ options: [T]) {
            self.options = options
        }

        public func withDefault(_ value: T) -> Self {
            self.defaultValue = value
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

        public func withConfig(_ config: CXPopupConfig) -> Self {
            self.config = config
            return self
        }

        public func create(on vc: UIViewController?) -> UIViewController {
            return CXPicker(options, config, defaultValue, message, handler, vc)
        }
    }

    class Picker: UIView, CXDialog, UITableViewDataSource, UITableViewDelegate {
        private let optionIdentifier = "_optionIdentifier"

        private let options: [T]
        private var defaultValue: T?
        private var message: String?
        private var handler: ((T) -> Void)?

        private var layout: UIStackView?

        init(_ options: [T], _ config: CXPopupConfig, _ defaultValue: T?, _ message: String?, _ handler: ((T) -> Void)?) {
            self.options = options
            self.defaultValue = defaultValue
            self.message = message
            self.handler = handler
            super.init(frame: .zero)
            build(config)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func build(_ config: CXPopupConfig) {
            layout = UIStackView()
            layout?.axis = .vertical
            layout?.distribution = .fill

            if let messageLayout = Picker.createMessageLayout(message, layoutStyle: config.layoutStyle) {
                layout?.addArrangedSubview(messageLayout)
            }

            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            layout?.addArrangedSubview(tableView)
            CXLayoutUtil.fill(layout!, at: self)
        }

        private static func createMessageLayout(_ message: String?, layoutStyle: CXLayoutStyle) -> UIView? {
            var height: CGFloat = 0
            guard let message = message else {
                return nil
            }
            let label = UILabel()
            label.text = message
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.textColor = .darkGray

            let width = layoutStyle.size.width
            let estimatedHeight = CXTextUtil.getTextSize(
                for: message,
                with: CGSize(width: width - CXSpacing.spacing4, height: CGFloat(Double.greatestFiniteMagnitude)),
                font: label.font).height
            height = estimatedHeight + CXSpacing.spacing4

            let layout = UIView()
            layout.backgroundColor = .white
            layout.heightAnchor.constraint(equalToConstant: height).isActive = true

            CXLayoutUtil.fill(label, at: layout, with: UIEdgeInsets(top: CXSpacing.spacing3, left: CXSpacing.spacing3, bottom: CXSpacing.spacing3, right: CXSpacing.spacing3))
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
            }
            let option = options[indexPath.row]
            cell?.textLabel?.text = option.getOptionText()

            if let defaultText = defaultValue?.getOptionText(), defaultText == option.getOptionText() {
//                cell?.accessoryType = .checkmark
                cell?.setHighlighted(true, animated: true)
            } else {
//                cell?.accessoryType = .none
            }

            return cell!
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44.0
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let option = options[indexPath.row]
            self.cxPopup?.dismiss(completion: { [weak self] in
                self?.handler?(option)
            })
        }
    }
}

extension CXPicker.Picker: CXPopupLifeCycleDelegate {
    func viewDidLoad() {
    }

    func viewDidDisappear() {
        handler = nil
    }
}

extension String: CXPickable {
    public func getOptionText() -> String {
        return self
    }
}
