//
//  UIViewController+.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/10/24.
//

import UIKit

extension UIViewController {
    
    func showClodyAlert(
        type: AlertType,
        title: String,
        message: String,
        rightButtonText: String
    ) {
        let alertViewController = ClodyAlertViewController(
            type: type,
            title: title,
            message: message,
            rightButtonText: rightButtonText
        )
        self.present(alertViewController, animated: true, completion: nil)
    }
}
