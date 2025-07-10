//
//  SplashViewController.swift
//  Clody_iOS
//
//  Created by 김나연 on 7/13/24.
//

import UIKit

import SnapKit
import Then

final class SplashViewController: UIViewController {
    
    private let symbolImageView = UIImageView()
    private let introImageView = UIImageView()
    private let clodyLogoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    private func setStyle(){
        view.backgroundColor = .mainYellow
        
        symbolImageView.do {
            $0.image = .imgSymbol
            $0.contentMode = .scaleAspectFit
        }
        
        introImageView.do {
            $0.image = .imgSlogan
            $0.contentMode = .scaleAspectFit
        }
        
        clodyLogoImageView.do {
            $0.image = .imgWordmark
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setHierarchy() {
        view.addSubviews(symbolImageView, introImageView, clodyLogoImageView)
    }
    
    private func setLayout() {
        symbolImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(296))
            $0.centerX.equalToSuperview()
        }
        
        introImageView.snp.makeConstraints {
            $0.top.equalTo(symbolImageView.snp.bottom).offset(ScreenUtils.getHeight(21))
            $0.centerX.equalToSuperview()
        }
        
        clodyLogoImageView.snp.makeConstraints {
            $0.top.equalTo(introImageView.snp.bottom).offset(ScreenUtils.getHeight(11))
            $0.centerX.equalToSuperview()
        }
    }
}
