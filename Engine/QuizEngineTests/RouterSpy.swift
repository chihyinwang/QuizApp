//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by chihyin wang on 2020/7/4.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import XCTest
import QuizEngine

class RouterSpy: Router {
    typealias QuestionType = String
    typealias Answer = String
    
    var routedQuestions: [QuestionType] = []
    var routedResult: Result<QuestionType, Answer>? = nil
    
    var answerCallback: (String) -> Void = { _ in }
    
    func routeTo(question: QuestionType, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func routeTo(result: Result<QuestionType, Answer>) {
        routedResult = result
    }
}
