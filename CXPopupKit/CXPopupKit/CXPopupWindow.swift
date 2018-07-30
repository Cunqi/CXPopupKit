//
//  CXPopupWindow.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public protocol CXPopupWindow where Self: UIViewController {
    var vc: UIViewController { get }
    
    func close()
    func closeWithPositiveAction(_ result: Any?)
    func closeWithNegativeAction(_ result: Any?)
    func invokePositiveAction(_ result: Any?)
    func invokeNegativeAction(_ result: Any?)
}

final class CXBasicPopupWindow: UIViewController, CXPopupWindow {
    var positiveAction: CXPopupAction?
    var negativeAction: CXPopupAction?
    var cxPresentationController: CXPresentationController?
    var popupAppearance = CXPopupAppearance()
    var contentView: CXPopupable?
    
    var vc: UIViewController {
        return self
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func closeWithPositiveAction(_ result: Any?) {
        invokePositiveAction(result)
        close()
    }
    
    func closeWithNegativeAction(_ result: Any?) {
        invokeNegativeAction(result)
        close()
    }
    
    func invokeNegativeAction(_ result: Any?) {
        negativeAction?(result)
    }
    
    func invokePositiveAction(_ result: Any?) {
        positiveAction?(result)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setup() {
        self.view.backgroundColor = popupAppearance.backgroundColor

        guard let contentView = self.contentView as? UIView else {
            return
        }
        addAndMakeViewFullScreen(contentView)
    }

    private func addAndMakeViewFullScreen(_ content: UIView) {
        view.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        content.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        content.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        content.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
}
