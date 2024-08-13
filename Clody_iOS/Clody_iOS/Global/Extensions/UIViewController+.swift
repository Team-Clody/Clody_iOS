//
//  UIViewController+.swift
//  Clody_iOS
//
//  Created by 김나연 on 8/14/24.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func linkToURL(url: String) {
        if let url = NSURL(string: url) {
            let safariViewController: SFSafariViewController = SFSafariViewController(url: url as URL)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
}
