//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import Foundation

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    
    var canSubmit: Bool {
        options.contains{ $0.isSelected }
    }
    
    private let handler: ([String]) -> Void
    
    init(options: [String], handler: @escaping ([String]) -> Void = { _ in }) {
        self.options = options.map { MultipleSelectionOption(text: $0) }
        self.handler = handler
    }
    
    func submit() {
        guard canSubmit else { return }
        handler(options.filter(\.isSelected).map(\.text))
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected = false
    
    mutating func select() {
        isSelected.toggle()
    }
}
