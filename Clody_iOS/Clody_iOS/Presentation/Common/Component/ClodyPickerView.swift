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
    case notification
    case calendar
}

final class ClodyPickerView: UIPickerView {
    
    // MARK: - Properties
    
    var type: PickerType
    lazy var timePeriods = ["오전", "오후"]
    lazy var hours = Array(1...12)
    lazy var minutes = [0, 10, 20, 30, 40, 50]
    lazy var years = Array(2000...2030)
    lazy var months = Array(1...12)
    
    // MARK: - Life Cycles
    
    init(type: PickerType) {
        self.type = type
        super.init(frame: .zero)
        
        setStyle()
        setDelegate()
        setDefaultInitialValues()
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
    
    private func setDefaultInitialValues() {
        switch type {
        case .notification:
            selectRow(1, inComponent: 0, animated: false)
            selectRow(8, inComponent: 1, animated: false)
            selectRow(3, inComponent: 2, animated: false)
        case .calendar:
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            if let yearIndex = years.firstIndex(of: currentYear) {
                selectRow(yearIndex, inComponent: 0, animated: false)
            }
            selectRow(currentMonth - 1, inComponent: 1, animated: false)
        }
    }
}

extension ClodyPickerView {
    
    func setTime(_ time: String) {
        if type == .notification {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            if let date = dateFormatter.date(from: time) {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minute = calendar.component(.minute, from: date)

                // 오전/오후 설정
                let periodIndex = (hour >= 12) ? 1 : 0
                selectRow(periodIndex, inComponent: 0, animated: false)

                // 시간 설정
                let adjustedHour = hour % 12
                if let hourIndex = hours.firstIndex(of: adjustedHour == 0 ? 12 : adjustedHour) {
                    selectRow(hourIndex, inComponent: 1, animated: false)
                }

                // 분 설정
                if let minuteIndex = minutes.firstIndex(of: minute) {
                    selectRow(minuteIndex, inComponent: 2, animated: false)
                }
            }
        }
    }
}

// MARK: - Extensions

extension ClodyPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch type {
        case .notification:
            return 65
        case .calendar:
            return 90
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel
        if let reusedLabel = view as? UILabel {
            label = reusedLabel
        } else {
            label = UILabel()
        }
        
        var text = ""
        switch type {
        case .notification:
            text = dataOfRowsInNotification(component: component, row: row)
        case .calendar:
            text = dataOfRowsInCalendar(component: component, row: row)
        }
        
        label.attributedText = UIFont.pretendardString(text: text, style: .head3_medium, color: .grey01)
        label.textAlignment = .center
        return label
    }
}

extension ClodyPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type {
        case .notification:
            return 3
        case .calendar:
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
    
    func numberOfRowsInNotification(_ component: Int) -> Int {
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
    
    func numberOfRowsInCalendar(_ component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        case 1:
            return months.count
        default:
            return 0
        }
    }
    
    func dataOfRowsInNotification(component: Int, row: Int) -> String {
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
    
    func dataOfRowsInCalendar(component: Int, row: Int) -> String {
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
