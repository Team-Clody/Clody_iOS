//
//  NotificationBottomSheetView.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class NotificationBottomSheetView: UIView {

    // MARK: - UI Components

    let titleLabel = UILabel()
    let closeButton = UIButton()
    var pickerView = ClodyPickerView(type: .notification)
    let doneButton = ClodyBottomButton(title: "완료")

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 10

        titleLabel.do {
            $0.textAlignment = .center
            $0.attributedText = UIFont.pretendardString(text: "다른 시간 보기", style: .body2_semibold)
            $0.textColor = .grey01
        }
        
        closeButton.do {
            $0.setImage(.icX, for: .normal)
        }

        addSubviews(titleLabel, closeButton, pickerView, doneButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(24)
        }

        pickerView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(doneButton)
            $0.bottom.equalTo(doneButton.snp.top).offset(8)
            $0.height.equalTo(223)
        }

        doneButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(5)
            $0.height.equalTo(48)
        }
    }
}
