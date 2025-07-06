//
//  String+.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/6/25.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
