//
//  ClodyPickerView.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/10/24.
//

import UIKit

import SnapKit
import Then

enum PickerType {
    case calendar
    case notification
}

final class ClodyPickerView: UIPickerView {
    
    // MARK: - Properties
    
    var type: PickerType
    lazy var timePeriods = ["오전", "오후"]
    lazy var hours = Array(1...12)
    lazy var minutes = [0, 10, 20, 30, 40, 50]
    lazy var years = [2020, 2021, 2022, 2023, 2024]
    lazy var months = Array(1...12)
    
    // MARK: - Life Cycles
    
    init(type: PickerType) {
        self.type = type
        super.init(frame: .zero)
        
        setStyle()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setStyle() {
        backgroundColor = .clear
    }
    
    private func setDelegate() {
        self.delegate = self
        self.dataSource = self
    }
}

// MARK: - Extensions

extension ClodyPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let reusedView = view as? UILabel {
            label = reusedView
        } else {
            label = UILabel()
        }
        
        switch type {
        case .calendar:
            label.text = dataOfRowsInCalendar(component: component, row: row)
        case .notification:
            label.text = dataOfRowsInNotification(component: component, row: row)
        }
        
        label.do {
            $0.textAlignment = .center
            $0.textColor = .grey01
            $0.font = .pretendard(.head3_medium)
        }
        
        return label
    }
}

extension ClodyPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type {
        case .calendar:
            return 3
        case .notification:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .calendar:
            return numberOfRowsInCalendar(component)
        case .notification:
            return numberOfRowsInNotification(component)
        }
    }
    
    func numberOfRowsInCalendar(_ component: Int) -> Int {
        switch component {
        case 0:
            return timePeriods.count
        case 1:
            return hours.count
        case 2:
            return minutes.count
        default:
            return 0
        }
    }
    
    func numberOfRowsInNotification(_ component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        case 1:
            return months.count
        default:
            return 0
        }
    }
    
    func dataOfRowsInCalendar(component: Int, row: Int) -> String {
        switch component {
        case 0:
            return timePeriods[row]
        case 1:
            return "\(hours[row])"
        case 2:
            return "\(minutes[row])"
        default:
            return ""
        }
    }
    
    func dataOfRowsInNotification(component: Int, row: Int) -> String {
        switch component {
        case 0:
            return "\(years[row])년"
        case 1:
            return "\(months[row])월"
        default:
            return ""
        }
    }
}
