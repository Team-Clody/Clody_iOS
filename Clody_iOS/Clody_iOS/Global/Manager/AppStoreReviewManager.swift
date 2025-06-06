//
//  AppStoreReviewManager.swift
//  Clody_iOS
//
//  Created by 김나연 on 6/6/25.
//

import StoreKit

enum AppStoreReviewManager {
    
    static func requestReview() {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}
