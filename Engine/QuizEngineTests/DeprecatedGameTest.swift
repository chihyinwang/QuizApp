//
//  GameTest.swift
//  QuizEngineTests
//
//  Created by chihyin wang on 2020/7/4.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine

@available(*, deprecated)
class DeprecatedGameTest: XCTestCase {
    
    private let router = RouterSpy()
    private var game: Game<String, String, RouterSpy>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        game = startGame(questions: ["Q1", "Q2"], router: router, correctAnswer: ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startGame_answerZeroOutOfTwoCorrectly_scores1() {
        router.answerCallback("Wrong Answer")
        router.answerCallback("Wrong Answer")
        
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    
    func test_startGame_answerOneOutOfTwoCorrectly_scores1() {
        router.answerCallback("A1")
        router.answerCallback("Wrong Answer")
        
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    
    func test_startGame_answerOneOutOfTwoCorrectly_scores2() {
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!.score, 2)
    }
    
    private class RouterSpy: Router {
        typealias QuestionType = String
        typealias Answer = String
        
        var routedResult: Result<QuestionType, Answer>? = nil
        
        var answerCallback: (String) -> Void = { _ in }
        
        func routeTo(question: QuestionType, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: Result<QuestionType, Answer>) {
            routedResult = result
        }
    }

}
