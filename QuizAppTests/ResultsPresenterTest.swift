//
//  ResultsPresenterTest.swift
//  QuizAppTests
//
//  Created by chihyin wang on 2020/7/6.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class ResultsPresenterTest: XCTestCase {

    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        
        let answer = [Question.singleAnswer("Q1"): ["A1"],
                      Question.multipleAnswer("Q2"): ["A2", "A3"]]
        
        let result = Result(answers: answer, score: 1)
        let sut = ResultsPresenter(result: result, correctAnswers: [:])
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswer_withoutQuestions_shouldBeEmpty() {
        let answer = Dictionary<Question<String>, [String]>()
        let result = Result(answers: answer, score: 0)
        
        let sut = ResultsPresenter(result: result, correctAnswers: [:])
        
        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswer_withWrongSingleQuestions_mapsAnswer() {
        let answer = [Question.singleAnswer("Q1"): ["A1"]]
        let correctionAnswers = [Question.singleAnswer("Q1"): ["A2"]]
        let result = Result(answers: answer, score: 0)
        
        let sut = ResultsPresenter(result: result, correctAnswers: correctionAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswer_withWrongMultipleQuestions_mapsAnswer() {
        let answer = [Question.multipleAnswer("Q1"): ["A2", "A3"]]
        let correctionAnswers = [Question.multipleAnswer("Q1"): ["A1", "A4"]]
        let result = Result(answers: answer, score: 0)
        
        let sut = ResultsPresenter(result: result, correctAnswers: correctionAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A4")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A2, A3")
    }
    
    func test_presentableAnswer_withRightSingleQuestions_mapsAnswer() {
        let answer = [Question.singleAnswer("Q1"): ["A2"]]
        let correctionAnswers = [Question.singleAnswer("Q1"): ["A2"]]
        let result = Result(answers: answer, score: 0)
        
        let sut = ResultsPresenter(result: result, correctAnswers: correctionAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
    }
    
    func test_presentableAnswer_withRightMultipleQuestions_mapsAnswer() {
        let answer = [Question.multipleAnswer("Q1"): ["A1", "A4"]]
        let correctionAnswers = [Question.multipleAnswer("Q1"): ["A1", "A4"]]
        let result = Result(answers: answer, score: 0)

        let sut = ResultsPresenter(result: result, correctAnswers: correctionAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
    }
    
}
