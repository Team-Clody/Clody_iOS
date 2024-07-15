//
//  ClodyToast.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/14/24.
//

import UIKit

import SnapKit

@frozen
enum ToastType {

}

final class ClodyToast {
    static func show (message: String, duration: TimeInterval = 1, isTabBar: Bool = true, completion: (() -> Void)? = nil) {
        let toastView = ClodyToastView()
        toastView.bindData(message: message)
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        window.subviews
            .filter { $0 is ClodyToastView }
            .forEach { $0.removeFromSuperview() }
        window.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(120)
            
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        window.layoutSubviews()
        
        fadeIn(completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                fadeOut(completion: {
                    completion?()
                })
            }
        })
        
        func fadeIn(completion: (() -> Void)? = nil) {
            toastView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                toastView.alpha = 1
            } completion: { _ in
                completion?()
            }
            
        }
        
        func fadeOut(completion: (() -> Void)? = nil) {
            toastView.alpha = 1
            UIView.animate(withDuration: 0.5) {
                toastView.alpha = 0
            } completion: { _ in
                toastView.removeFromSuperview()
                completion?()
            }
        }
    }
}