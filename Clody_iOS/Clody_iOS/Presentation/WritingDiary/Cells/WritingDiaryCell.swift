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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setHierarchy()
        setLayout()
        setDelegate()
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
            $0.returnKeyType = .done
        }
        
        kebabButton.do {
            $0.setImage(.kebob, for: .normal)
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
    }
    
    private func setHierarchy() {
        self.addSubviews(
            writingContainer,
            textView,
            textInputLabel,
            limitTextLabel,
            writingListNumberLabel,
            kebabButton
        )
    }
    
    private func setLayout() {
        
        textView.snp.makeConstraints {
            $0.top.equalTo(writingListNumberLabel)
            $0.leading.equalToSuperview().inset(34)
            $0.trailing.equalTo(kebabButton.snp.leading)
        }
        
        writingListNumberLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        writingContainer.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(textView).inset(-14)
        }
        
        textInputLabel.snp.makeConstraints {
            $0.centerY.equalTo(limitTextLabel)
            $0.trailing.equalTo(limitTextLabel.snp.leading).offset(-2)
        }
        
        limitTextLabel.snp.makeConstraints {
            $0.top.equalTo(writingContainer.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        kebabButton.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.top.equalToSuperview().inset(11)
            $0.trailing.equalToSuperview().inset(6)
        }
    }
    
    private func setDelegate() {
        textView.delegate = self
    }
    
    func bindData(
        index: Int,
        text: String,
        statuses: Bool,
        isFirst: Bool
    ) {
        writingListNumberLabel.text = "\(index)."
        textInputLabel.text = "\(text.count)"
        if !isFirst {
            writingListNumberLabel.textColor = .grey02
            textView.textColor = .grey03
        } else {
            writingListNumberLabel.textColor = .grey06
            textView.textColor = .grey06
        }
        
        if statuses {
            textView.text = text.isEmpty ? I18N.WritingDiary.placeHolder : text
            writingContainer.makeBorder(width: 0, color: .clear)
        } else {
            writingContainer.makeBorder(width: 1, color: .red)
            textView.text = ""
            textInputLabel.text = "0"
        }
    }
}


extension WritingDiaryCell: UITextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
