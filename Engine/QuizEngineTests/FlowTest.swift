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

    func test_start_withNoQuestions_doesNotDelegatesQuestionHandling() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_delegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_delegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_delegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstCorrectQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesntDelegateNextQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        delegate.answerCompletion("A1")

        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_doesNotCompleteQuiz() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestion_completeWithEmptyQuiz() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestion_doesntNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletion("A1")

        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_completesQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { _ in 10 })
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

        XCTAssertEqual(delegate.handledResult!.score, 10)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scoresWithRightAnswers() {
        var receivedAnswer = [String: String]()
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { answer in
            receivedAnswer = answer
            return 20
        })
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")

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
        let sut = Flow(questions: questions, delegate: delegate, scoring: scoring)
        weakSUT = sut
        return sut
    }
    
    private func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)", file: file, line: line)
    }
    
    private class DelegateSpy: QuizDelegate {
        typealias QuestionType = String
        typealias Answer = String
        
        var handledQuestions: [QuestionType] = []
        var handledResult: Result<QuestionType, Answer>? = nil
        var completedQuizzes: [[(String, String)]] = []
        
        var answerCompletion: (String) -> Void = { _ in }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCompletion = completion
        }
        
        func didCompleteQuiz(withAnswers answers: [(answers: String, answer: String)]) {
            completedQuizzes.append(answers)
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
    }

}
