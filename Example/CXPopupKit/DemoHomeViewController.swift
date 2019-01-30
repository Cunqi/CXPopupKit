//
//  DemoHomeViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 1/29/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

enum DemoItem {
    static let customView = "CustomView"
    static let alertView = "Alert View"
    static let picker = "Picker"
    static let datePicker = "DatePicker"
}

class DemoHomeViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let demoItemArray = [
        DemoItem.customView,
        DemoItem.alertView,
        DemoItem.picker,
        DemoItem.datePicker
    ]
    private static let itemIdentifier = "_demoItemIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Demo List"
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension DemoHomeViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoItemArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: DemoHomeViewController.itemIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: DemoHomeViewController.itemIdentifier)
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = demoItemArray[indexPath.row]
        return cell ?? UITableViewCell()
    }
}

extension DemoHomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = demoItemArray[indexPath.row]
        switch item {
        case DemoItem.customView:
            self.performSegue(withIdentifier: item, sender: nil)
        case DemoItem.alertView:
            break
        case DemoItem.picker:
            break
        case DemoItem.datePicker:
            break
        default:
            break
        }
    }
}