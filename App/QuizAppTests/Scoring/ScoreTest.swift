//
//  ScoreTest.swift
//  QuizAppTests
//
//  Created by chihyin wang on 2020/7/13.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizApp

class ScoreTest: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [String()]), 0)
    }
    
    func test_oneNonMatchingAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["wrongAnswer"], comparingTo: ["an answer"]), 0)
    }
    
    func test_oneMatchingAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["an answer"], comparingTo: ["an answer"]), 1)
    }
    
    func test_oneMatchingAnswers_oneNonMatchingAnswer_scoresOne() {
        let score = BasicScore.score(
            for: ["an answer", "wrong"],
            comparingTo: ["an answer", "another answers"])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoMatchingAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: ["an answer", "another answers"],
            comparingTo: ["an answer", "another answers"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyAnswers_twoMatchingAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: ["an answer", "another answers", "an extra answer"],
            comparingTo: ["an answer", "another answers"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyAnswers_oneMatchingAnswers_scoresOne() {
        let score = BasicScore.score(
            for: ["not matching answer", "another answers", "an extra answer"],
            comparingTo: ["an answer", "another answers"])
        XCTAssertEqual(score, 1)
    }
    
}
