//
//  WritingDiaryCell.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/10/24.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class WritingDiaryCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    let writingContainer = UIView()
    let writingListNumberLabel = UILabel()
    lazy var textView = UITextView()
    lazy var kebabButton = UIButton()
    let textInputLabel = UILabel()
    let limitTextLabel = UILabel()
    let limitErrorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        resetCellState()
    }
    
    private func resetCellState() {
        textView.text = I18N.WritingDiary.placeHolder
        textInputLabel.text = "0"
        writingContainer.makeBorder(width: 0, color: .clear)
        writingContainer.backgroundColor = .white
    }
    
    private func setStyle() {
        self.backgroundColor = .white
        
        writingContainer.do {
            $0.backgroundColor = .grey09
            $0.makeCornerRound(radius: 10)
        }
        
        writingListNumberLabel.do {
            $0.attributedText = UIFont.pretendardString(
                text: "1.",
                style: .body3_semibold,
                lineHeightMultiple: 1.5
            )
            $0.textColor = .grey06
        }
        
        textView.do {
            $0.attributedText = UIFont.pretendardString(
                text: I18N.WritingDiary.placeHolder,
                style: .body3_medium,
                lineHeightMultiple: 1.5
            )
            $0.textColor = .grey06
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.textContainerInset = .zero
            $0.textContainer.lineFragmentPadding = 0
            $0.returnKeyType = .default
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        kebabButton.do {
            $0.setImage(.kebob, for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        
        textInputLabel.do {
            $0.attributedText = UIFont.pretendardString(
                text: "0",
                style: .detail1_medium,
                lineHeightMultiple: 1.5
            )
            $0.textColor = .grey04
        }
        
        limitTextLabel.do {
            $0.attributedText = UIFont.pretendardString(
                text: "/ 50",
                style: .detail1_medium,
                lineHeightMultiple: 1.5
            )
            $0.textColor = .grey06
        }
        
        limitErrorLabel.do {
            $0.attributedText = UIFont.pretendardString(
                text: I18N.WritingDiary.inputLimitError,
                style: .detail1_medium,
                lineHeightMultiple: 1.5
            )
            $0.textColor = .redCustom
            $0.isHidden = true
        }
    }
    
    private func setHierarchy() {
        self.contentView.addSubviews(writingContainer, textInputLabel, limitTextLabel, limitErrorLabel)
        writingContainer.addSubviews(writingListNumberLabel, textView, kebabButton)
    }
    
    private func setLayout() {
        
        writingContainer.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        writingListNumberLabel.snp.makeConstraints {
            $0.top.equalTo(textView)
            $0.leading.equalToSuperview().inset(ScreenUtils.getHeight(16))
        }

        textView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(ScreenUtils.getHeight(14))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(34))
            $0.trailing.equalTo(kebabButton.snp.leading)
        }

        kebabButton.snp.makeConstraints {
            $0.size.equalTo(ScreenUtils.getWidth(28))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(6))
            $0.centerY.equalTo(writingListNumberLabel)
        }
        
        limitErrorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(ScreenUtils.getWidth(8))
            $0.centerY.equalTo(limitTextLabel)
        }

        textInputLabel.snp.makeConstraints {
            $0.trailing.equalTo(limitTextLabel.snp.leading).offset(ScreenUtils.getWidth(-2))
            $0.centerY.equalTo(limitTextLabel)
        }
        textInputLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        limitTextLabel.snp.makeConstraints {
            $0.top.equalTo(writingContainer.snp.bottom).offset(ScreenUtils.getHeight(6))
            $0.trailing.equalToSuperview().inset(ScreenUtils.getWidth(8))
            $0.bottom.equalToSuperview()
        }
        limitTextLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func bindData(index: Int, text: String, isPlaceholder: Bool) {
        writingListNumberLabel.text = "\(index)."
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let textCount = trimmedText.count
        textInputLabel.text = "\(textCount)"

        let isEmpty = trimmedText.isEmpty
        let isTooShort = textCount < 2

        if isEmpty {
            if isPlaceholder {
                // 아직 입력 안 한 상태
                textView.text = I18N.WritingDiary.placeHolder
                textView.textColor = .grey06
                writingListNumberLabel.textColor = .grey06
                writingContainer.backgroundColor = .grey09
                writingContainer.makeBorder(width: 0, color: .clear)
                limitErrorLabel.isHidden = true
            } else {
                // 입력했다가 다 지운 상태 → 에러
                textView.text = ""
                textView.textColor = .grey03
                writingListNumberLabel.textColor = .grey02
                writingContainer.backgroundColor = .white
                writingContainer.makeBorder(width: 1, color: .red)
                limitErrorLabel.isHidden = true
            }
        } else if isTooShort {
            // 글자 수 1
            textView.text = text
            textView.textColor = .grey03
            writingListNumberLabel.textColor = .grey02
            writingContainer.backgroundColor = .white
            writingContainer.makeBorder(width: 1, color: .red)
            limitErrorLabel.isHidden = false
        } else {
            // 정상 입력 상태
            textView.text = text
            textView.textColor = .grey03
            writingListNumberLabel.textColor = .grey02
            writingContainer.backgroundColor = .grey09
            writingContainer.makeBorder(width: 0, color: .clear)
            limitErrorLabel.isHidden = true
        }
    }

    
    func updateUIOnBeginEditing() {
        writingContainer.makeBorder(width: 1, color: .mainYellow)
        if textView.text == I18N.WritingDiary.placeHolder {
            textView.text = ""
        }
        writingListNumberLabel.textColor = .grey02
        textView.textColor = .grey03
        writingContainer.backgroundColor = .white
    }
}
