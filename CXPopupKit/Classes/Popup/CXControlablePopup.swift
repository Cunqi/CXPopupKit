//
//  CXControlablePopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 2/16/19.
//

import UIKit

public class CXControlablePopup<T: CXDialog>: CXPopup {
    
    init(_ view: T, _ title: String?, _ leftTappable: (text: String, action: ((T) -> Void)?)?, _ rightTappable: (text: String, action: ((T) -> Void)?)?, _ config: CXPopupConfig, _ delegate: CXPopupLifeCycleDelegate?, _ configuration: ((UINavigationBar) -> Void)?, _ vc: UIViewController?) {
        let wrapperView = ControlWrapperView(view, title, leftTappable, rightTappable, config, configuration)
        super.init(wrapperView, wrapperView.config, delegate, vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class ControlWrapperView: UIView, CXDialog {
        var config: CXPopupConfig
        private var navigationBar: UINavigationBar
        private let content: T
        var leftTappable: (text: String, action: ((T) -> Void)?)?
        var rightTappable: (text: String, action: ((T) -> Void)?)?
        
        init(_ view: T, _ title: String?, _ leftTappable: (text: String, action: ((T) -> Void)?)?, _ rightTappable: (text: String, action: ((T) -> Void)?)?, _ config: CXPopupConfig, _ configuration: ((UINavigationBar) -> Void)?) {
            self.content = view
            self.config = config
            self.leftTappable = leftTappable
            self.rightTappable = rightTappable
            self.navigationBar = UINavigationBar()
            super.init(frame: .zero)
            
            let navigationItem = UINavigationItem(title: title ?? "")
            if let left = leftTappable {
                let leftBarButtonItem = UIBarButtonItem(title: left.text, style: .plain, target: self, action: #selector(didTapLeft))
                navigationItem.leftBarButtonItem = leftBarButtonItem
            }
            
            if let right = rightTappable {
                let rightBarButtonItem = UIBarButtonItem(title: right.text, style: .plain, target: self, action: #selector(didTapRight))
                navigationItem.rightBarButtonItem = rightBarButtonItem
            }
            navigationBar.pushItem(navigationItem, animated: true)
            navigationBar.isTranslucent = false
            configuration?(navigationBar)
            
            let stackView = UIStackView(arrangedSubviews: [navigationBar, content])
            stackView.axis = .vertical
            stackView.distribution = .fill
            CXLayoutUtil.fill(stackView, at: self)
            
            let originSize = config.layoutStyle.size
            let updatedSize = CGSize(width: UIScreen.main.bounds.width, height: originSize.height + navigationBar.bounds.height)
            self.config.layoutStyle.update(size: updatedSize)
            self.config.safeAreaGapColor = navigationBar.barTintColor ?? UIColor.white
        }
        
        @objc private func didTapLeft() {
            guard let left = leftTappable else {
                return
            }
//            self.cxPopup?.dismiss({ [weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//                left.action?(strongSelf.content)
//            })
        }
        
        @objc private func didTapRight() {
            guard let right = rightTappable else {
                return
            }
//            self.cxPopup?.dismiss({ [weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//                right.action?(strongSelf.content)
//            })
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    public class Builder {
        let view: T
        var config: CXPopupConfig
        var title: String?
        var configuration: ((UINavigationBar) -> Void)?
        var leftTappable: (text: String, action: ((T) -> Void)?)?
        var rightTappable: (text: String, action: ((T) -> Void)?)?
        
        weak var delegate: CXPopupLifeCycleDelegate?
        
        public init(_ view: T) {
            self.view = view
            self.config = CXPopupConfig()
        }
        
        public func withTitle(_ title: String) -> Self {
            self.title = title
            return self
        }
        
        public func withLeft(_ text: String, _ handler: ((T) -> Void)?) -> Self {
            self.leftTappable = (text, handler)
            return self
        }
        
        public func withRight(_ text: String, _ handler: ((T) -> Void)?) -> Self {
            self.rightTappable = (text, handler)
            return self
        }
        
        public func withConfig(_ config: CXPopupConfig) -> Self {
            self.config = config
            return self
        }
        
        public func withDelegate(_ delegate: CXPopupLifeCycleDelegate) -> Self {
            self.delegate = delegate
            return self
        }
        
        public func withConfiguration(_ configuration: @escaping (UINavigationBar) -> Void) -> Self {
            self.configuration = configuration
            return self
        }
        
        public func create(on vc: UIViewController?) -> CXPopup {
            return CXControlablePopup<T>(view, title, leftTappable, rightTappable, config, delegate, configuration, vc)
        }
    }
}
