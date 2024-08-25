//
//  UIViewController+.swift
//  Clody_iOS
//
//  Created by 김나연 on 8/14/24.
//

import UIKit
import SafariServices

import SnapKit

extension UIViewController {
    
    func linkToURL(url: String) {
        if let url = NSURL(string: url) {
            let safariViewController: SFSafariViewController = SFSafariViewController(url: url as URL)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    private struct AssociatedKeys {
        static var loadingIndicator = "loadingIndicator"
        static var dimmingView = "dimmingView"
        static var errorAlertView = "errorAlertView"
        static var errorRetryView = "errorRetryView"
        static var retryAction = "retryAction"
        static var retryCount = "retryCount"
    }
    
    private var retryCount: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.retryCount) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.retryCount, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
        
    private var loadingIndicator: UIActivityIndicatorView {
        get {
            if let indicator = objc_getAssociatedObject(self, &AssociatedKeys.loadingIndicator) as? UIActivityIndicatorView {
                return indicator
            } else {
                let indicator = UIActivityIndicatorView(style: .large)
                indicator.color = .gray
                objc_setAssociatedObject(self, &AssociatedKeys.loadingIndicator, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return indicator
            }
        }
    }
    
    private var dimmingView: UIView {
        get {
            if let view = objc_getAssociatedObject(self, &AssociatedKeys.dimmingView) as? UIView {
                return view
            } else {
                let view = UIView()
                view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                objc_setAssociatedObject(self, &AssociatedKeys.dimmingView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return view
            }
        }
    }
    
    private var errorAlertView: ClodyErrorAlertView {
        get {
            if let view = objc_getAssociatedObject(self, &AssociatedKeys.errorAlertView) as? ClodyErrorAlertView {
                return view
            } else {
                let view = ClodyErrorAlertView()
                objc_setAssociatedObject(self, &AssociatedKeys.errorAlertView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return view
            }
        }
    }
    
    private var errorRetryView: ClodyErrorRetryView {
        get {
            if let view = objc_getAssociatedObject(self, &AssociatedKeys.errorRetryView) as? ClodyErrorRetryView {
                return view
            } else {
                let view = ClodyErrorRetryView()
                objc_setAssociatedObject(self, &AssociatedKeys.errorRetryView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return view
            }
        }
    }
    
    func showLoadingIndicator() {

        view.addSubviews(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        dimmingView.removeFromSuperview()
    }
    
    func showErrorAlert(isNetworkError: Bool) {
        if isNetworkError {
            errorAlertView.titleLabel.attributedText = UIFont.pretendardString(
                text: I18N.Error.network,
                style: .body3_medium,
                lineHeightMultiple: 1.5
            )
        } else {
            errorAlertView.titleLabel.attributedText = UIFont.pretendardString(
                text: I18N.Error.unKnown,
                style: .body3_medium,
                lineHeightMultiple: 1.5
            )
        }
        
        self.view.addSubview(errorAlertView)
        
        errorAlertView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showRetryView(isNetworkError: Bool, retryAction: @escaping () -> Void) {
        if isNetworkError {
            errorAlertView.titleLabel.attributedText = UIFont.pretendardString(
                text: I18N.Error.network,
                style: .body2_semibold,
                lineHeightMultiple: 1.5
            )
        } else {
            errorAlertView.titleLabel.attributedText = UIFont.pretendardString(
                text: I18N.Error.unKnown,
                style: .body2_semibold,
                lineHeightMultiple: 1.5
            )
        }

        self.view.addSubview(errorRetryView)
        
        errorRetryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        errorRetryView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        // Store the retry action
        objc_setAssociatedObject(self, &AssociatedKeys.retryAction, retryAction, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    
    @objc private func retryButtonTapped() {
        
        retryCount += 1
        
        if retryCount < 4 {
            hideRetryView()
            
            if let retryAction = objc_getAssociatedObject(self, &AssociatedKeys.retryAction) as? () -> Void {
                retryAction()
            }
        }
    }
    
    func hideRetryView() {
        errorRetryView.removeFromSuperview()
    }
}
