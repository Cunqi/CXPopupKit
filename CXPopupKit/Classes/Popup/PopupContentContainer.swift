//
//  PopupContentContainer.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/9/19.
//

import UIKit


/// Used to wrap any custom view that passed in by user, since
/// we use this container as the childViewController in PopupController,
/// it's necessary to wrap the custom view to make sure everything on the same page.
class PopupContentContainer: UIViewController, CXDialog {
    private let content: CXView

    init(_ content: CXView) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = content
    }

    func tapLeftBarButtonItem(_ action: CXPopupNavigateAction) {
        content.tapLeftBarButtonItem(action)
    }

    func tapRightBarButtonItem(_ action: CXPopupNavigateAction) {
        content.tapRightBarButtonItem(action)
    }
}

