//
//  CXActivityIndicator.swift
//  CXPopupKit
//
//  Created by Cunqi on 2/12/19.
//

import UIKit

public typealias CXActivityIndicatorStyle = CXProgressBarSize
public protocol CXActivityIndicatorInteractable {
    func startAnimating()
    func stopAnimating()
}

public class CXActivityIndicator: CXPopup, CXActivityIndicatorInteractable {
    private var config: CXProgressConfig
    private let activityIndicatorView: CXActivityIndicatorView
    
    init(_ config: CXProgressConfig, _ vc: UIViewController?) {
        self.config = config
        
        let finalSize = CGSize(
            width: config.progressBarSize.size.width + CXSpacing.spacing4,
            height: config.progressBarSize.size.height + CXSpacing.spacing4)
        self.config.popupConfig.layoutStyle.update(size: finalSize)
        self.config.popupConfig.padding = UIEdgeInsets(CXSpacing.spacing3)
        self.config.popupConfig.popupBackgroundColor = self.config.backgroundColor
        self.activityIndicatorView = CXActivityIndicatorView()
        self.activityIndicatorView.config = config
        super.init(activityIndicatorView, self.config.popupConfig, activityIndicatorView, vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    public func stopAnimating() {
        self.dismiss()
    }
    
    public class Builder {
        private var config = CXProgressConfig()
        
        public init() {}
        
        public func withBackgroundColor(_ backgroundColor: UIColor) -> Self {
            config.backgroundColor = backgroundColor
            return self
        }
        
        public func withBarBackgroundColor(_ barBackgroundColor: UIColor) -> Self {
            config.barBackgroundColor = barBackgroundColor
            return self
        }
        
        public func withBarForegroundColor(_ barForegroundColor: UIColor) -> Self {
            config.barForegroundColor = barForegroundColor
            return self
        }
        
        public func withStyle(_ style: CXActivityIndicatorStyle) -> Self {
            config.progressBarSize = style
            return self
        }
        
        public func create(on vc: UIViewController?) -> CXActivityIndicator {
            return CXActivityIndicator(config, vc)
        }
    }
}
