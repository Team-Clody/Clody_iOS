//
//  DeleteBottomSheetController.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/14/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class DeleteBottomSheetController: UIViewController {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let rootView = DeleteBottomSheetView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindActions()
    }
    
    private func bindActions() {
        rootView.deleteContainer.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissBottomSheet(animated: true, completion: {
                    print("tap delete")
                })
            })
            .disposed(by: disposeBag)
        
        rootView.dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissBottomSheet(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func presentBottomSheet(on parent: UIViewController) {
        rootView.dimmedView.alpha = 0.0
        parent.addChild(self)
        parent.view.addSubview(view)
        didMove(toParent: parent)
        
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rootView.animateShow()
    }
    
    private func dismissBottomSheet(animated: Bool, completion: (() -> Void)?) {
        rootView.animateHide {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            completion?()
        }
    }
}
