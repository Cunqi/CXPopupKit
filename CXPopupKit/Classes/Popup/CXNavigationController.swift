//
//  CXNavigationController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/29/19.
//

import UIKit

public enum CXPopupNavigateAction {
    case cancel(text: String)
    case action(text: String)

    var text: String {
        switch self {
        case .cancel(let text):
            return text
        case .action(let text):
            return text
        }
    }
}

class CXNavigationController: UINavigationController, CXDialog {
    private weak var dialog: CXDialog?
    private var leftAction: CXPopupNavigateAction?
    private var rightAction: CXPopupNavigateAction?

    convenience init(title: String?, left: CXPopupNavigateAction?, right: CXPopupNavigateAction?, view: CXView) {
        let contentContainer = PopupContentContainer(view)
        self.init(title: title, left: left, right: right, viewController: contentContainer)
    }

    init(title: String?, left: CXPopupNavigateAction?, right: CXPopupNavigateAction?, viewController: CXViewController) {
        super.init(rootViewController: viewController)
        dialog = viewController
        viewController.navigationItem.title = title
        viewController.navigationController?.navigationBar.isTranslucent = false

        if let leftText = left?.text {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: leftText, style: .plain, target: self, action: #selector(didTapLeftBarButtonItem(_:)))
            self.leftAction = left
        }

        if let rightText = right?.text {
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightText, style: .plain, target: self, action: #selector(didTapRightBarButtonItem(_:)))
            self.rightAction = right
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapLeftBarButtonItem(_ sender: UIBarButtonItem) {
        dialog?.tapLeftBarButtonItem(self.leftAction!)
    }

    @objc private func didTapRightBarButtonItem(_ sender: UIBarButtonItem) {
        dialog?.tapRightBarButtonItem(self.rightAction!)
    }
}
