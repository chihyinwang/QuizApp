//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by chihyin wang on 2020/7/6.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
@testable import QuizEngine

extension Result {
    
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result {
        return Result(answers: answers, score: score)
    }
}

extension Result: Equatable where Answer: Hashable {
    
    public static func ==(lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score && lhs.answers == rhs.answers
    }
}

extension Result: Hashable where Answer: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answers)
        hasher.combine(score)
    }
}
