//
//  ClodyAlert.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/9/24.
//

import UIKit

import SnapKit
import Then

enum AlertType {
    case logout
    case withdraw
    case deleteDiary
    case saveDiary
}

final class ClodyAlertViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let alertView: ClodyAlert
    
    // MARK: - Properties
    
    var type: AlertType {
        get { return alertView.type }
    }
    
    // MARK: - Life Cycles
    
    init(
        type: AlertType,
        title: String,
        message: String,
        rightButtonText: String
    ) {
        self.alertView = ClodyAlert(type, title, message, rightButtonText)
        super.init(nibName: nil, bundle: nil)
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 1
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ClodyAlertViewController {
    
    // MARK: - Methods
    
    func setStyle() {
        self.modalPresentationStyle = .fullScreen
        view.backgroundColor = .white.withAlphaComponent(0.4)
    }
    
    func setHierarchy() {
        view.addSubview(alertView)
    }
    
    func setLayout() {
        alertView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
        }
    }
}

final class ClodyAlert: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    let leftButton = UIButton()
    let rightButton = UIButton()
    
    // MARK: - Properties
    
    var type: AlertType
    
    // MARK: - Life Cycles

    init(
        _ type: AlertType,
        _ title: String,
        _ message: String,
        _ rightButtonText: String
    ) {
        self.type = type
        super.init(frame: .zero)
        
        setStyle(with: title, message, rightButtonText)
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ClodyAlert {
    
    // MARK: - Methods
    
    private func setStyle(
        with title: String,
        _ message: String,
        _ rightButtonText: String
    ) {
        backgroundColor = .white
        makeCornerRound(radius: 12)
        
        switch type {
        case .logout, .saveDiary:
            rightButton.backgroundColor = .mainYellow
            rightButton.setTitleColor(.grey01, for: .normal)
        case .withdraw, .deleteDiary:
            rightButton.backgroundColor = .redCustom
            rightButton.setTitleColor(.white, for: .normal)
        }
        
        titleLabel.do {
            $0.text = title
            $0.textColor = .grey01
            $0.font = .pretendard(.body1_semibold)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        messageLabel.do {
            $0.text = message
            $0.textColor = .grey04
//            $0.font = .pretendard(.popup_regular)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        leftButton.do {
            $0.backgroundColor = .grey07
            $0.setTitle(I18N.Alert.cancel, for: .normal)
            $0.titleLabel?.font = .pretendard(.body3_semibold)
            $0.setTitleColor(.grey04, for: .normal)
            $0.makeCornerRound(radius: 8)
        }
        
        rightButton.do {
            $0.setTitle(rightButtonText, for: .normal)
            $0.titleLabel?.font = .pretendard(.body3_semibold)
            $0.makeCornerRound(radius: 8)
        }
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel, messageLabel, leftButton, rightButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27)
            $0.horizontalEdges.greaterThanOrEqualToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.horizontalEdges.greaterThanOrEqualToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.width.equalTo(rightButton)
            $0.height.equalTo(42)
            $0.top.equalTo(messageLabel.snp.bottom).offset(34)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        rightButton.snp.makeConstraints {
            $0.height.equalTo(leftButton)
            $0.leading.equalTo(leftButton.snp.trailing).offset(9)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(leftButton)
        }
    }
}
