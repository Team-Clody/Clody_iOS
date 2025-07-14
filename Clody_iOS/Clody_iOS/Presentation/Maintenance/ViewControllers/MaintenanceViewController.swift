//
//  MaintenanceViewController.swift
//  Clody_iOS
//
//  Created by Seonwoo Kim on 7/13/25.
//

import UIKit

import SnapKit
import Then

final class MaintenanceViewController: UIViewController {
    
    private let maintenanceView = MaintenanceView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        
        maintenanceView.confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
    }
    
    func configureContent(time: String) {
        maintenanceView.configureContent(time: time)
    }
    
    private func setStyle(){
        view.backgroundColor = .mainYellow
    }
    
    private func setHierarchy() {
        view.addSubview(maintenanceView)
    }
    
    private func setLayout() {
        maintenanceView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func didTapConfirm() {
        exit(0)
    }
}
