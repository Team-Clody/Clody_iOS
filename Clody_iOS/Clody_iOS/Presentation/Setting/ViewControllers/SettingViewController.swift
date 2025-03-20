//
//  SettingViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 9/19/24.
//

import UIKit

import RxCocoa
import RxSwift

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = SettingViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let rootView = SettingView()
    private lazy var tableView = rootView.tableView
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
        setDelegate()
    }
}

// MARK: - Extensions

private extension SettingViewController {
    
    func bindViewModel() {
        let input = SettingViewModel.Input(
            backButtonTapEvent: rootView.navigationBar.backButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.popViewController
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func setUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingList.itemCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return .init() }
        
        let item = SettingList.allCases.filter { $0.section == indexPath.section }[indexPath.row]
        cell.configure(item: item)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = SettingList.allCases.filter { $0.section == indexPath.section }[indexPath.row]
        
        switch item {
        case .profile:
            navigationController?.pushViewController(AccountViewController(), animated: true)
        case .notification:
            navigationController?.pushViewController(NotificationViewController(), animated: true)
        case .terms:
            linkToURL(url: I18N.TermsURL.terms)
        case .privacy:
            linkToURL(url: I18N.TermsURL.privacy)
        case .announcement:
            linkToURL(url: I18N.TermsURL.announcement)
        case .contactUs:
            linkToURL(url: I18N.TermsURL.contactUs)
        default:
            return
        }
    }
}
