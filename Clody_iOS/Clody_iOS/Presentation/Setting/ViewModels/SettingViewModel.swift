//
//  SettingViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 9/19/24.
//

import RxCocoa
import RxSwift

enum SettingList: CaseIterable {
    case profile
    case notification
    case announcement
    case contactUs
    case terms
    case privacy
    case version

    var title: String {
        switch self {
        case .profile: return .Setting.profile
        case .notification: return .Setting.notification
        case .announcement: return .Setting.announcement
        case .contactUs: return .Setting.contactUs
        case .terms: return .Setting.terms
        case .privacy: return .Setting.privacy
        case .version: return .Setting.version
        }
    }

    var section: Int {
        switch self {
        case .profile: return 0
        case .notification, .announcement, .contactUs: return 1
        case .terms, .privacy, .version: return 2
        }
    }
    
    static func itemCount(for section: Int) -> Int {
        return SettingList.allCases.filter { $0.section == section }.count
    }
    
    static func sectionCount() -> Int {
        return Set(SettingList.allCases.map { $0.section }).count
    }
}

final class SettingViewModel: ViewModelType {
    
    struct Input {
        let backButtonTapEvent: Signal<Void>
    }
    
    struct Output {
        let popViewController: Driver<Void>
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let popViewController = input.backButtonTapEvent
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            popViewController: popViewController
        )
    }
}
