//
//  ScreenUtils.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/11/24.
//

import UIKit

final class ScreenUtils {
    
    static func getWidth(_ value: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let standardWidth: CGFloat = 375.0
        return width / standardWidth * value
    }
    
    static func getHeight(_ value: CGFloat) -> CGFloat {
        let height = UIScreen.main.bounds.height
        let standardHeight: CGFloat = 812.0
        return height / standardHeight * value
    }
}
