//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class ResultsPresenterTest: XCTestCase {
    
    func test_title_returnsFormattedTitle() {
        XCTAssertEqual(makeSUT().title, "Result")
    }

    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let userAnswers = [(singleAnswerQuestion, ["A1"]),
                           (multipleAnswerQuestion, ["A2", "A3"])]
        let correctAnswers = [(singleAnswerQuestion, ["A1"]),
                              (multipleAnswerQuestion, ["A2"])]
        
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers, score: 1)
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswer_withoutQuestions_shouldBeEmpty() {
        XCTAssertTrue(makeSUT().presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswer_withWrongSingleQuestions_mapsAnswer() {
        let userAnswer = [(singleAnswerQuestion, ["A1"])]
        let correctionAnswers = [(singleAnswerQuestion, ["A2"])]
        
        let sut = makeSUT(userAnswers: userAnswer, correctAnswers: correctionAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswer_withWrongMultipleQuestions_mapsAnswer() {
        let userAnswer = [(multipleAnswerQuestion, ["A2", "A3"])]
        let correctionAnswers = [(multipleAnswerQuestion, ["A1", "A4"])]
        let sut = makeSUT(userAnswers: userAnswer, correctAnswers: correctionAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A4")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A2, A3")
    }
    
    func test_presentableAnswer_withRightMultipleQuestions_mapsOrederedAnswer() {
        let userAnswer = [(singleAnswerQuestion, ["A1"]),
                          (multipleAnswerQuestion, ["A2", "A4"])]
        let correctionAnswers = [(singleAnswerQuestion, ["A1"]),
                                 (multipleAnswerQuestion, ["A2", "A4"])]
        
        let sut = makeSUT(userAnswers: userAnswer, correctAnswers: correctionAnswers, score: 2)
        
        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)

        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A2, A4")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }
    
    // MARK: - Helpers
    
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    private func makeSUT(userAnswers: ResultsPresenter.Answers = [],
                 correctAnswers: ResultsPresenter.Answers = [],
                 score: Int = 0
    ) -> ResultsPresenter {
        ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: { _, _ in score })
    }
    
}
