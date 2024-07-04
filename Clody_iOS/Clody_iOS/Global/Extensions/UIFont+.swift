//
//  UIFont+.swift
//  Clody_iOS
//
//  Created by 오서영 on 6/30/24.
//

import UIKit

enum FontName {
    case head1, head2, head3, head4, head5
    case body1_semibold, body2_semibold, body3_semibold
    case body1_medium, body2_medium, body3_medium, body4_medium
    case detail1_semibold, detail2_semibold
    case detail1_medium, detail2_medium
    case detail2_help

    var rawValue: String {
        switch self {
        case .head1, .head2, .head3, .head4, .head5, .body1_semibold, .body2_semibold, .body3_semibold, .detail1_semibold, .detail2_semibold:
            return "Pretendard-SemiBold"
        case .body1_medium, .body2_medium, .body3_medium, .body4_medium, .detail1_medium, .detail2_medium:
            return "Pretendard-Medium"
        case .detail2_help:
            return "Pretendard-Regular"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .head1:
            return 23
        case .head2:
            return 20
        case .head3:
            return 18
        case .head4:
            return 17
        case .head5:
            return 16
        case .body1_semibold, .body1_medium:
            return 15
        case .body2_semibold, .body2_medium, .body4_medium:
            return 14
        case .body3_semibold, .body3_medium:
            return 13
        case .detail1_semibold, .detail1_medium, .detail2_help:
            return 12
        case .detail2_semibold, .detail2_medium:
            return 10
        }
    }
}

extension UIFont {
    static func pretendard(_ style: FontName) -> UIFont {
        return UIFont(name: style.rawValue, size: style.size)!
    }
    
    static func pretendardString(text: String, style: FontName) -> NSAttributedString {
        let font = UIFont.pretendard(style)
        let letterSpacing = -0.003 * style.size
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: letterSpacing
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
