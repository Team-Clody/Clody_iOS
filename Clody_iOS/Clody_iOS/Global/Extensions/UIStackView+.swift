//
//  UIStackView+.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/29/24.
//

import UIKit

extension UIStackView {
    func addArrangeSubViews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
