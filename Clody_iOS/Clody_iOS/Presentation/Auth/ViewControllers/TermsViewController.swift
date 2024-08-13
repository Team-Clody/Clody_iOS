//
//  TermsViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/11/24.
//

import UIKit
import SafariServices

import RxCocoa
import RxSwift
import Then

final class TermsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = TermsViewModel()
    private let disposeBag = DisposeBag()
    private var signUpInfo: SignUpInfoModel
    
    // MARK: - UI Components
     
    private let rootView = TermsView()
    
    // MARK: - Life Cycles
    
    init(signUpInfo: SignUpInfoModel) {
        self.signUpInfo = signUpInfo
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
}

// MARK: - Extensions

private extension TermsViewController {

    func bindViewModel() {
        let allAgreeTextButtonTapEvent = rootView.allAgreeTextButton.rx.tap
            .map {
                let isSelected = self.rootView.allAgreeIconButton.isSelected
                return !isSelected
            }
            .asSignal(onErrorJustReturn: false)
        
        let allAgreeIconButtonTapEvent = rootView.allAgreeIconButton.rx.tap
            .map {
                let isSelected = self.rootView.allAgreeIconButton.isSelected
                return !isSelected
            }
            .asSignal(onErrorJustReturn: false)
        
        let input = TermsViewModel.Input(
            allAgreeTextButtonTapEvent: allAgreeTextButtonTapEvent,
            allAgreeIconButtonTapEvent: allAgreeIconButtonTapEvent,
            viewTermsDetailButtonTapEvent: rootView.viewTermsDetailButton.rx.tap.asSignal(),
            viewPrivacyDetailButtonTapEvent: rootView.viewPrivacyDetailButton.rx.tap.asSignal(),
            nextButtonTapEvent: rootView.nextButton.rx.tap.asSignal(),
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        _ = rootView.agreeTermsIconButton.rx.tap
            .map {
                let isSelected = self.rootView.agreeTermsIconButton.isSelected
                self.rootView.agreeTermsIconButton.isSelected = !isSelected
                return !isSelected
            }
            .bind(to: input.agreeTermsButtonTapEvent)
            .disposed(by: disposeBag)
        
        _ = rootView.agreePrivacyIconButton.rx.tap
            .map {
                let isSelected = self.rootView.agreePrivacyIconButton.isSelected
                self.rootView.agreePrivacyIconButton.isSelected = !isSelected
                return !isSelected
            }
            .bind(to: input.agreePrivacyButtonTapEvent)
            .disposed(by: disposeBag)
        
        output.twoAgreeCombineEvent
            .drive(onNext: { isBothAgree in
                self.rootView.allAgreeIconButton.isSelected = isBothAgree
            })
            .disposed(by: disposeBag)
        
        output.allAgreeButtonMergeEvent
            .drive(onNext: { isAllAgree in
                input.agreeTermsButtonTapEvent.accept(isAllAgree)
                input.agreePrivacyButtonTapEvent.accept(isAllAgree)
                self.rootView.allAgreeIconButton.isSelected = isAllAgree
                self.rootView.agreeTermsIconButton.isSelected = isAllAgree
                self.rootView.agreePrivacyIconButton.isSelected = isAllAgree
            })
            .disposed(by: disposeBag)

        output.nextButtonIsEnabled
            .drive(onNext: { isEnabled in
                self.rootView.nextButton.setEnabledState(to: isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.linkToTermsDetail
            .drive(onNext: {
                self.linkToURL(url: I18N.TermsURL.terms)
            })
            .disposed(by: disposeBag)
        
        output.linkToPrivacyDetail
            .drive(onNext: {
                self.linkToURL(url: I18N.TermsURL.privacy)
            })
            .disposed(by: disposeBag)
        
        output.pushViewController
            .drive(onNext: { _ in
                self.navigationController?.pushViewController(NicknameViewController(signUpInfo: self.signUpInfo), animated: true)
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
    
    func linkToURL(url: String) {
        if let url = NSURL(string: url) {
            let safariViewController: SFSafariViewController = SFSafariViewController(url: url as URL)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
}
