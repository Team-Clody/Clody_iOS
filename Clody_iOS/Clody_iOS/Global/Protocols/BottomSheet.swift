//
//  BottomSheet.swift
//  Clody_iOS
//
//  Created by 김나연 on 6/5/25.
//

import UIKit

protocol BottomSheet where Self: UIView {
    func animateShow()
    func animateHide(completion: @escaping () -> Void)
}
