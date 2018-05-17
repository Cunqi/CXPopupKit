//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/18/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import UIKit

public typealias CXPopupHandler = (Any?) -> Void
public typealias CXPopupLifeCycleAction = () -> Void

//public final class CXPopup {
//    public var appearance: CXPopupAppearance {
//        get {
//            return window.appearance
//        }
//        set {
//            window.appearance = newValue
//        }
//    }
//
//    public var positiveAction: CXPopupHandler? {
//        get {
//            return window.positiveAction
//        }
//        set {
//            window.positiveAction = newValue
//        }
//    }
//
//    public var negativeAction: CXPopupHandler? {
//        get {
//            return window.negativeAction
//        }
//        set {
//            window.negativeAction = newValue
//        }
//    }
//
//    public var cxWindow: UIViewController {
//        return window
//    }
//
//    deinit {
//        print("CXPopup deinit")
//    }
//
//    private var window = CXPopupWindow(with: UIView())
//    private var presentationController: CXPresentationController?
//
//    public init(with popupable: CXPopupable) {
//        window.popupable = popupable
//    }
//
//    public func show(at presenter: UIViewController?) {
//        presentationController = CXPresentationController(presentedViewController: window, presenting: presenter)
//        presentationController?.appearance = appearance
//        window.transitioningDelegate = presentationController
//        presenter?.present(window, animated: true, completion: nil)
//    }
//
//    public func completeWithNegative(result: Any?) {
//        window.negativeAction?(result)
//        window.dismiss(animated: true, completion: nil)
//    }
//
//    public func completeWithPositive(result: Any?) {
//        window.positiveAction?(result)
//        window.dismiss(animated: true, completion: nil)
//    }
//}
