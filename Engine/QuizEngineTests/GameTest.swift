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

class GameTest: XCTestCase {
    
    let router = RouterSpy()
    var game: Game<String, String, RouterSpy>!
    
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
    
}
