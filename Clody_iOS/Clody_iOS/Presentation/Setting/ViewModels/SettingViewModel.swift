//
//  SettingViewModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 9/19/24.
//

import UIKit

import RxCocoa
import RxSwift

protocol SettingList {
    var title: String { get }
}

enum Section0: SettingList, CaseIterable {
    case profile
    
    var title: String {
        return "프로필 및 계정 관리"
    }
}

enum Section1: SettingList, CaseIterable {
    case notification
    case announcement
    case contactUs
    
    var title: String {
        switch self {
        case .notification: return "알림 설정"
        case .announcement: return "공지사항"
        case .contactUs: return "문의/제안하기"
        }
    }
}

enum Section2: SettingList, CaseIterable {
    case terms
    case privacy
    case version
    
    var title: String {
        switch self {
        case .terms: return "서비스 이용 약관"
        case .privacy: return "개인정보 처리방침"
        case .version: return "앱 버전"
        }
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
