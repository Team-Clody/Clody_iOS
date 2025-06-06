//
//  AppStoreReviewManager.swift
//  Clody_iOS
//
//  Created by 김나연 on 6/6/25.
//

import StoreKit

enum AppStoreReviewManager {
    private static let hasRequestedReview_Key = "hasRequestedReview"
    private static let hasViewedReply_Key = "hasViewedReply"
    
    static func requestReviewIfNeeded() {
        guard !hasRequestedReview && hasViewedReply else { return }
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
        
        hasRequestedReview = true
    }
    
    static func markReplyAsViewed() {
        hasViewedReply = true
    }
}

extension AppStoreReviewManager {
    
    private static var hasRequestedReview: Bool {
        get { UserDefaults.standard.bool(forKey: hasRequestedReview_Key) }
        set { UserDefaults.standard.set(newValue, forKey: hasRequestedReview_Key) }
    }
    
    private static var hasViewedReply: Bool {
        get { UserDefaults.standard.bool(forKey: hasViewedReply_Key) }
        set { UserDefaults.standard.set(newValue, forKey: hasViewedReply_Key) }
    }
}
