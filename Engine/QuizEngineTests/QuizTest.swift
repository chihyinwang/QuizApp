//
//  QuizTest.swift
//  QuizEngineTests
//
//  Created by chihyin wang on 2020/7/10.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {
    
    private let delegate = DelegateSpy()
    private var quiz: Quiz!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswer: ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scores1() {
        delegate.answerCompletion("Wrong Answer")
        delegate.answerCompletion("Wrong Answer")
        
        XCTAssertEqual(delegate.handedResult!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scores1() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("Wrong Answer")
        
        XCTAssertEqual(delegate.handedResult!.score, 1)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scores2() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handedResult!.score, 2)
    }
    
    private class DelegateSpy: QuizDelegate {
        typealias QuestionType = String
        typealias Answer = String
        
        var handedResult: Result<QuestionType, Answer>? = nil
        
        var answerCompletion: (String) -> Void = { _ in }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
        
        func handle(result: Result<String, String>) {
            handedResult = result
        }
    }

}
