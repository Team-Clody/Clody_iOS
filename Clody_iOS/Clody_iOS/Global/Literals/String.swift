//
//  String.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 6/30/24.
//

import Foundation

enum I18N {
    
    enum Common {
        static let year = "년"
        static let month = "월"
        static let enterNickname = "닉네임을 입력해주세요"
        static let enterEmail = "이메일을 입력해주세요"
        static let nicknameCondition = "특수문자, 띄어쓰기 불가"
        static let nicknameError = "사용할 수 없는 닉네임이에요"
        static let emailError = "이메일 형식을 확인해주세요"
        static let charLimit = "/ 10"
    }
    
    enum Alert {
        static let logoutTitle = "로그아웃 하시겠어요?"
        static let logoutMessage = "기다릴게요, 다음에 다시 만나요!"
        static let withdrawTitle = "서비스를 탈퇴하시겠어요?"
        static let withdrawMessage = "작성하신 일기와 받은 답장 및 클로버가 모두 삭제되며 복구할 수 없어요."
        static let saveDiaryTitle = "일기를 저장할까요?"
        static let saveDiaryMessage = "저장한 일기는 수정이 어려워요."
        static let deleteDiaryTitle = "정말 일기를 삭제할까요?"
        static let deleteDiaryMessage = "삭제한 일기는 복원이 어려워요."
        static let cancel = "취소"
        static let logout = "로그아웃"
        static let withdraw = "탈퇴할래요"
        static let save = "저장하기"
        static let delete = "삭제하기"
    }
}
