//
//  CalenderDateCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

//
//  CalenderDateCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/28/24.
//

import UIKit

import FSCalendar
import SnapKit

final class CalenderDateCell: FSCalendarCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        self.backgroundColor = .cyan
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    func setStyle() {
    }
    
    func setHierarchy() {
        contentView.addSubviews()
    }
    
    func setLayout() {
    }
}

extension CalenderDateCell {
    
    func configure() {
    }
}
