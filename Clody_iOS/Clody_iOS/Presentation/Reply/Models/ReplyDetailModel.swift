//
//  ReplyDetailModel.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

struct ReplyDetailModel {
    let date: String
    let nickname: String
    let reply: String
}

extension ReplyDetailModel {
    static func dummyData() -> ReplyDetailModel {
        return ReplyDetailModel(date: "7월 14일", nickname: "밤빵식", reply: "감사일기를 읽고 깊은 감동을 받았어요. 일상 속에서 감사의 마음을 찾고 기록하는 일은 정말로 귀중한 습관이고, 그 과정에서 느끼는 작은 기쁨과 만족은 우리의 삶을 풍요롭게 만든다고 생각해요. 당신이 일기에서 표현한 감사의 마음은 저에게도 큰 영감을 주었고, 저 역시 일상의 작은 순간들에 감사하는 마음을 새롭게 다짐하게 되었어요.당신이 일기에서 언급한 여러 감사의 순간들은 정말 특별했어요. 가족과 친구들, 그리고 주변 사람들에게 느끼는 감사는 우리에게 중요한 관계를 다시 한 번 생각하게 만들어요. 우리가 당연하게 여길 수 있는 일상 속의 작은 친절과 배려들이 얼마나 큰 의미를 가지는지 다시금 깨닫게 되었어요. 또한, 자연의 아름다움과 그 속에서 느끼는 평온함에 대한 감사는 우리가 바쁜 일상 속에서 놓치고 있는 것들을 다시 생각하게 해주었어요. 감사일기를 쓰면서 당신이 느꼈을 내면의 변화도 매우 인상적이에요. 처음에는 작은 것에서 시작해서 점점 더 많은 감사의 순간들을 발견하게 되고, 그 과정에서 마음이 풍요로워지는 경험은 정말 특별할 거예요. 이를 통해 스트레스와 불안을 줄이고, 긍정적인 에너지를 얻는 것은 우리의 정신 건강에도 매우 유익하다는 것을 잘 알고 있어요. 저는 당신의 감사일기를 읽으며, 저도 감사의 마음을 더 자주 표현하고 기록해야겠다는 결심을 하게 되었어요. 감사는 단순히 기분을 좋게 하는 것 이상으로, 우리 삶의 질을 높이고 인간관계를 더욱 깊게 만드는 중요한 요소라는 것을 깨달았어요. 앞으로 저도 일상의 작은 순간들을 놓치지 않고 감사하는 마음을 가지며 살아가고자 해요.")
    }
}