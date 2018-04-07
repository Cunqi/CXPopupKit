//
//  DemoListViewController.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 4/7/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

class DemoListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private let items: [DemoListItem] = [.basic, .alertView, .picker]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        title = "Demo"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension DemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoListItem", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = String(describing: item)
        return cell
    }
}

extension DemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        switch item {
        case .basic:
            showBasicDemoScreen()
        default:
            break
        }
    }

    private func showBasicDemoScreen() {
        self.performSegue(withIdentifier: "BasicDemoViewController", sender: nil)
    }
}
