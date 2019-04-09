//
//  DemoHomeViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 1/29/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CXPopupKit

enum DemoItem {
    static let customView = "CustomView"
    static let alertView = "Alert View"
    static let picker = "Picker"
    static let datePicker = "DatePicker"
    static let toast = "Toast"
    static let progressBar = "ProgressBar"
}

class DemoHomeViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let demoItemArray = [
        DemoItem.customView,
        DemoItem.alertView,
        DemoItem.picker,
        DemoItem.datePicker,
        DemoItem.toast,
        DemoItem.progressBar
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
        if item == DemoItem.toast {
            CXToast("In many apps that use a UITableView, when a UITableViewCell is ... This can be done programmatically in tableView:didSelectRowAtIndexPath:, but .... We'll do that with the tableView method “indexPathForSelectedRow()").toast()
        } else {
            self.performSegue(withIdentifier: item, sender: nil)
        }
    }
}
