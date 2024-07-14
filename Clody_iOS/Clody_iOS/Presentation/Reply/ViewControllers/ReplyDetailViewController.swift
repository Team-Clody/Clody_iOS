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
    private let nickname = "밤빵식"
    
    // MARK: - UI Components
    
    private let rootView = ReplyDetailView()
    private lazy var getClodyAlertView = GetCloverAlertView(nickname: nickname)
    private let dimmingView = UIView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAlert()
    }
}

// MARK: - Extensions

private extension ReplyDetailViewController {

    func bindViewModel() {
        let input = ReplyDetailViewModel.Input(
            okButtonTapEvent: getClodyAlertView.okButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.dismissAlert
            .drive(onNext: { [weak self] in
                self?.hideAlert()
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
    
    func showAlert() {
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
