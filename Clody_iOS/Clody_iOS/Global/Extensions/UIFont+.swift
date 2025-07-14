//
//  UIFont+.swift
//  Clody_iOS
//
//  Created by 오서영 on 6/30/24.
//

import UIKit

enum FontName {
    case head1, head2, head3, head3_medium, head4
    case body1_semibold, body1_medium
    case body2_semibold, body2_medium
    case body3_semibold, body3_medium, body3_regular
    case body4_semibold, body4_medium
    case detail1_semibold, detail1_medium, detail1_regular
    case detail2_semibold, detail2_medium
    case letter_medium

    var pretendardFont: String {
        switch self {
        case .head1, .head2, .head3, .head4, .body1_semibold, .body2_semibold, .body3_semibold, .body4_semibold, .detail1_semibold, .detail2_semibold:
            return "Pretendard-SemiBold"
        case .head3_medium, .body1_medium, .body2_medium, .body3_medium, .body4_medium, .detail1_medium, .detail2_medium, .letter_medium:
            return "Pretendard-Medium"
        case .body3_regular, .detail1_regular:
            return "Pretendard-Regular"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .head1:
            return 22
        case .head2:
            return 20
        case .head3, .head3_medium:
            return 18
        case .head4:
            return 17
        case .body1_semibold, .body1_medium:
            return 16
        case .body2_semibold, .body2_medium:
            return 15
        case .body3_semibold, .body3_medium, .body3_regular, .letter_medium:
            return 14
        case .body4_semibold, .body4_medium:
            return 13
        case .detail1_semibold, .detail1_medium, .detail1_regular:
            return 12
        case .detail2_semibold, .detail2_medium:
            return 10
        }
    }
    
    var lineHeightMultiple: CGFloat {
        switch LocalizationConstant.languageCode {
        case "ko": return ko_lineHeightMultiple
        default: return en_lineHeightMultiple
        }
    }
    
    private var en_lineHeightMultiple: CGFloat {
        switch self {
        case .head1, .head2, .head3, .head3_medium, .head4:
            return 1.4
        case .body1_semibold, .body1_medium,
                .body2_semibold, .body2_medium,
                .body3_semibold, .body3_medium, .body3_regular,
                .body4_semibold, .body4_medium,
                .detail1_semibold, .detail1_medium, .detail1_regular,
                .detail2_semibold, .detail2_medium:
            return 1.3
        case .letter_medium:
            return 1.8
        }
    }
    
    private var ko_lineHeightMultiple: CGFloat {
        self == .letter_medium ? 1.9 : 1.5
    }
    
    var letterSpacing: CGFloat {
        switch LocalizationConstant.languageCode {
        case "ko": return -0.003
        default: return 0
        }
    }
}

extension UIFont {
    static func pretendard(_ style: FontName) -> UIFont {
        return UIFont(name: style.pretendardFont, size: style.size)!
    }
    
    static func pretendardString(
        text: String, 
        style: FontName,
        color: UIColor? = nil,
        applyLineHeight: Bool = false,
        align: NSTextAlignment? = nil
    ) -> NSAttributedString {
        let font = UIFont.pretendard(style)
        let letterSpacingValue = style.letterSpacing * style.size
        let paragraphStyle = NSMutableParagraphStyle()
        if applyLineHeight {
            paragraphStyle.minimumLineHeight = style.size * style.lineHeightMultiple
            paragraphStyle.maximumLineHeight = style.size * style.lineHeightMultiple
        }
        if let alignment = align {
            paragraphStyle.alignment = alignment
        }
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: letterSpacingValue,
            .paragraphStyle: paragraphStyle
        ]
        
        if let color = color {
            attributes[.foregroundColor] = color
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
