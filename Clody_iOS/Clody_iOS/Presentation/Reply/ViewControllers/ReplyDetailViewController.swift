//
//  ReplyDetailViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/14/24.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class ReplyDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let rootView = ReplyDetailView()
    private let getClodyAlertView = GetCloverAlertView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
        showAlert()
    }
}

// MARK: - Extensions

private extension ReplyDetailViewController {

    func bindViewModel() {
    }

    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
