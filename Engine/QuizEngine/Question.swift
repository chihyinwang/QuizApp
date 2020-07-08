//
//  Question.swift
//  QuizEngine
//
//  Created by chihyin wang on 2020/7/7.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

public enum Question<T: Hashable> : Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .singleAnswer(let a):
            hasher.combine(a)
        case .multipleAnswer(let a):
            hasher.combine(a)
        }
    }
    
    public var hashValue: Int {
        switch self {
        case .singleAnswer(let a):
            return a.hashValue
        case .multipleAnswer(let a):
        return a.hashValue
        }
    }
}

