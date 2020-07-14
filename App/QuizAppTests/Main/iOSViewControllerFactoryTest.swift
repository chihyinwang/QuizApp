//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by chihyin wang on 2020/7/5.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class iOSViewControllerFactoryTest: XCTestCase {

    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    let options = ["A1", "A2"]
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: .singleAnswer("Q1")).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController().options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionController().allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: .multipleAnswer("Q1")).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: .multipleAnswer("Q1")).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        XCTAssertTrue(makeQuestionController(question: .multipleAnswer("Q1")).allowsMultipleSelection)
    }
    
    func test_resultsViewController_createsControllerWithTitle() {
        let (controller, presenter) = makeResults()
        XCTAssertEqual(controller.title, presenter.title)
    }
    
    func test_resultsViewController_createsControllerWithSummary() {
        let (controller, presenter) = makeResults()
        XCTAssertEqual(controller.summary, presenter.summary)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let (controller, presenter) = makeResults()
        XCTAssertEqual(controller.answers.count, presenter.presentableAnswers.count)
    }
    
    // MARK: - Helpers
    
    func makeSUT(options: Dictionary<Question<String>, [String]> = [:], correctAnswers: Dictionary<Question<String>, [String]> = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
    }
    
    func makeSUT(options: Dictionary<Question<String>, [String]> = [:], correctAnswers: [(Question<String>, [String])] = []) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = .singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options], correctAnswers: [:]).questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
    }
    
    func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let correctAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]
        
        let result = Result.make(
            answers: [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]],
            score: 2)
        
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: { _, _ in result.score })
        
        let sut = makeSUT(correctAnswers: correctAnswers)
        
        let controller = sut.resultViewController(for: result) as! ResultsViewController
        
        return (controller, presenter)
    }
    
}
