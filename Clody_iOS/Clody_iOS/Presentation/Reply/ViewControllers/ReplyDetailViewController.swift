//
//  ReplyDetailViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ReplyDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = ReplyDetailViewModel()
    private let disposeBag = DisposeBag()
    private let nickname: String
    private let content: String
    private let month: Int
    private let date: Int
    private let isNew: Bool
    
    // MARK: - UI Components
    
    private lazy var rootView = ReplyDetailView(
        month: month,
        date: date,
        nickname: nickname,
        content: content
    )
    private lazy var getClodyAlertView = GetCloverAlertView(nickname: nickname)
    private lazy var dimmingView = UIView()
    
    // MARK: - Life Cycles
    
    init(data: GetReplyResponseDTO, isNew: Bool) {
        self.nickname = data.nickname
        self.content = data.content
        self.month = data.month
        self.date = data.date
        self.isNew = isNew
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        judgeIsAlert(isNew: isNew)
    }
}

// MARK: - Extensions

private extension ReplyDetailViewController {

    func bindViewModel() {
        let input = ReplyDetailViewModel.Input(
            okButtonTapEvent: getClodyAlertView.okButton.rx.tap.asSignal(),
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.dismissAlert
            .drive(onNext: { [weak self] in
                self?.hideAlert()
            })
            .disposed(by: disposeBag)
        
        output.popViewController
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setStyle() {
        dimmingView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.2)
        }
        
        getClodyAlertView.do {
            $0.alpha = 0
        }
    }
    
    func setHierarchy() {
        view.addSubviews(dimmingView, getClodyAlertView)
    }
    
    func setLayout() {
        dimmingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        getClodyAlertView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(ScreenUtils.getWidth(56))
            $0.center.equalToSuperview()
        }
    }
    
    func judgeIsAlert(isNew: Bool) {
        if isNew {
            showAlert()
        }
    }
    
    func showAlert() {
        setStyle()
        setHierarchy()
        setLayout()
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.getClodyAlertView.alpha = 1
        })
    }
    
    func hideAlert() {
        UIView.animate(withDuration: 0.5, animations: {
            self.getClodyAlertView.alpha = 0
        }) { _ in
            self.dimmingView.removeFromSuperview()
            self.getClodyAlertView.removeFromSuperview()
        }
    }
}
