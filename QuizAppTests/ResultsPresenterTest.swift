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
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")

    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        
        let answer = [singleAnswerQuestion: ["A1"],
                      multipleAnswerQuestion: ["A2", "A3"]]
        
        let result = Result(answers: answer, score: 1)
        let sut = ResultsPresenter(result: result,
                                   questions: [singleAnswerQuestion,
                                               multipleAnswerQuestion],
                                   correctAnswers: [:])
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswer_withoutQuestions_shouldBeEmpty() {
        let answer = Dictionary<Question<String>, [String]>()
        let result = Result(answers: answer, score: 0)
        
        let sut = ResultsPresenter(result: result, questions: [], correctAnswers: [:])
        
        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswer_withWrongSingleQuestions_mapsAnswer() {
        let answer = [singleAnswerQuestion: ["A1"]]
        let correctionAnswers = [singleAnswerQuestion: ["A2"]]
        let result = Result(answers: answer, score: 0)
        
        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion], correctAnswers: correctionAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswer_withWrongMultipleQuestions_mapsAnswer() {
        let answer = [multipleAnswerQuestion: ["A2", "A3"]]
        let correctionAnswers = [multipleAnswerQuestion: ["A1", "A4"]]
        let result = Result(answers: answer, score: 0)
        
        let sut = ResultsPresenter(result: result, questions: [multipleAnswerQuestion], correctAnswers: correctionAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A4")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A2, A3")
    }
    
    func test_presentableAnswer_withRightMultipleQuestions_mapsOrederedAnswer() {
        let answer = [singleAnswerQuestion: ["A1"],
                      multipleAnswerQuestion: ["A2", "A4"]]
        let correctionAnswers = [multipleAnswerQuestion: ["A2", "A4"],
                                 singleAnswerQuestion: ["A1"]]
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let result = Result(answers: answer, score: 2)

        let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: correctionAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)

        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A2, A4")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }
    
}
