//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest

class ScoreTest: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: []), 0)
    }
    
    func test_oneWrongAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["wrongAnswer"], comparingTo: ["correct"]), 0)
    }
    
    func test_oneCorrectAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["correct"], comparingTo: ["correct"]), 1)
    }
    
    func test_twoAnswers_oneCorrectAnswer_scoresOne() {
        let score = BasicScore.score(
            for: ["correct1", "wrong"],
            comparingTo: ["correct1", "correct2"])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoAnswers_twoCorrectAnswer_scoresOne() {
        let score = BasicScore.score(
            for: ["correct1", "correct2"],
            comparingTo: ["correct1", "correct2"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withUnequalSizeData() {
        let score1 = BasicScore.score(for: ["", "", ""],comparingTo: ["", ""])
        XCTAssertEqual(score1, 2)
    }
    
    private class BasicScore {
        static func score(for answers: [String], comparingTo correctAnswers: [String] = []) -> Int {
            if answers.isEmpty { return 0 }
            
            var score = 0
            for (index, answer) in answers.enumerated() {
                if index >= correctAnswers.count { return score }
                score += answer == correctAnswers[index] ? 1 : 0
            }
            
            return score
        }
    }
}
 
