//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by chihyin wang on 2020/6/26.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    private let delegate = DelegateSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_routesToCorrectQuestion_1() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_routesToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(delegate.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToCorrectQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToCorrectQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routesToThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesntRouteToNextQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        delegate.answerCallback("A1")

        XCTAssertEqual(delegate.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestion_routesToResult() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.routedResult!.answers, [:])
    }
    
    func test_startWithFirstQuestion_withOneQuestion_routesToResult() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertNil(delegate.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_doesntRoutesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCallback("A1")

        XCTAssertNil(delegate.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.routedResult!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { _ in 10 })
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.routedResult!.score, 10)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scoresWithRightAnswers() {
        var receivedAnswer = [String: String]()
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { answer in
            receivedAnswer = answer
            return 20
        })
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(receivedAnswer, ["Q1": "A1", "Q2": "A2"])
    }
    
    // MARK: - Helpers
    
    private weak var weakSUT: Flow<DelegateSpy>?
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        XCTAssertNil(weakSUT)
    }
    
    private func makeSUT(questions: [String],
                         scoring: @escaping (([String: String]) -> Int) = { _ in 0 }) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, router: delegate, scoring: scoring)
        weakSUT = sut
        return sut
    }
    
    private class DelegateSpy: Router, QuizDelegate {
        typealias QuestionType = String
        typealias Answer = String
        
        var routedQuestions: [QuestionType] = []
        var routedResult: Result<QuestionType, Answer>? = nil
        
        var answerCallback: (String) -> Void = { _ in }
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(question: QuestionType, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func handle(result: Result<String, String>) {
            routedResult = result
        }
        
        func routeTo(result: Result<QuestionType, Answer>) {
            handle(result: result)
        }
    }

}
