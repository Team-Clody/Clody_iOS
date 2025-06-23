//
//  DiaryState.swift
//  Clody_iOS
//
//  Created by 김나연 on 6/23/25.
//

import UIKit

final class DiaryState {
    private(set) var items: [DiaryItem] = [DiaryItem()]
    
    var canAddItem: Bool {
        items.count < 5
    }
    
    var hasValidItems: Bool {
        items.allSatisfy { $0.isValid }
    }
    
    var hasAnyContent: Bool {
        items.contains { !$0.isEmpty }
    }
    
    func addItem() {
        guard canAddItem else { return }
        items.append(DiaryItem())
    }
    
    func removeItem(at index: Int) {
        guard index < items.count, items.count > 1 else { return }
        items.remove(at: index)
    }
    
    func updateItem(at index: Int, text: String) {
        guard index < items.count else { return }
        let limitedText = String(text.prefix(50))
        items[index].text = limitedText
        items[index].isPlaceholder = false
    }
    
    func setPlaceholder(at index: Int, isPlaceholder: Bool) {
        guard index < items.count else { return }
        items[index].isPlaceholder = isPlaceholder
    }
    
    func getTexts() -> [String] {
        items.map { $0.text }
    }
    
    func loadDraftData(_ texts: [String]) {
        items = texts.map { DiaryItem(text: $0, isPlaceholder: $0.isEmpty) }
        if items.isEmpty {
            items = [DiaryItem()]
        }
    }
}
