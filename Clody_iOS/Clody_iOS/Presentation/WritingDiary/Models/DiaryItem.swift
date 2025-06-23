//
//  DiaryItem.swift
//  Clody_iOS
//
//  Created by 김나연 on 6/23/25.
//

import UIKit

struct DiaryItem {
    var text: String
    var isPlaceholder: Bool
    var isEditing: Bool = false
    
    init(text: String = "", isPlaceholder: Bool = true, isEditing: Bool = false) {
        self.text = text
        self.isPlaceholder = isPlaceholder
        self.isEditing = isEditing
    }
    
    var trimmedText: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValid: Bool {
        !isPlaceholder && trimmedText.count >= 2
    }
    
    var isEmpty: Bool {
        trimmedText.isEmpty
    }
    
    var displayText: String {
        isPlaceholder ? I18N.WritingDiary.placeHolder : text
    }
    
    var textColor: UIColor {
        isPlaceholder ? .grey06 : .grey03
    }
    
    var containerBackgroundColor: UIColor {
        if isEditing || borderColor == .redCustom { return .white }
        return .grey09
    }
    
    var borderColor: UIColor {
        if isPlaceholder { return .clear }
        if showErrorMessage || isEmpty || trimmedText.count < 2 { return .redCustom }
        return .clear
    }
    
    var borderWidth: CGFloat {
        borderColor == .clear ? 0 : 1
    }
    
    var numberLabelColor: UIColor {
        isPlaceholder ? .grey06 : .grey02
    }
    
    var showErrorMessage: Bool {
        !isPlaceholder && !isEmpty && trimmedText.count < 2
    }
}
