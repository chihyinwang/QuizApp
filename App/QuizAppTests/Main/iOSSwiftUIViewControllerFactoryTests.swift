//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import SwiftUI
import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class iOSSwiftUIViewControllerFactoryTests: XCTestCase {

    func test_questionViewController_singleAnswer_createsControllerWithTitle() throws {
        let presenter = QuestionPresenter(questions: questions, question: singleAnswerQuestion)
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        
        XCTAssertEqual(view.title, presenter.title)
    }

    func test_questionViewController_singleAnswer_createsControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())

        XCTAssertEqual(view.question, "Q1")
    }
 
    func test_questionViewController_singleAnswer_createsControllerWithOptions() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())

        XCTAssertEqual(view.options, options[singleAnswerQuestion])
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithAnswerCallback() throws {
        var answers = [[String]]()
        let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { answers.append($0) }))
        
        XCTAssertEqual(answers, [])
        
        view.selection(view.options[0])
        XCTAssertEqual(answers, [[view.options[0]]])
        
        view.selection(view.options[1])
        XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: questions, question: multipleAnswerQuestion)
        let controller = makeQuestionController(question: multipleAnswerQuestion)

        XCTAssertEqual(controller.title, presenter.title)
    }

    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)

        XCTAssertEqual(controller.question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)

        XCTAssertEqual(controller.options, options[multipleAnswerQuestion])
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        
        XCTAssertTrue(controller.allowsMultipleSelection)
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

    // MARK: Helpers
    
    private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    
    private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q2") }
    
    private var questions: [Question<String>] {
        [singleAnswerQuestion, multipleAnswerQuestion]
    }
    
    private var options: [Question<String>: [String]] {
        [singleAnswerQuestion: ["A1", "A2", "A3"], multipleAnswerQuestion: ["A4", "A5", "A6"]]
    }
    
    private var correctAnswers: [(Question<String>, [String])] {
        [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4", "A5"])]
    }

    private func makeSUT() -> iOSSwiftUIViewControllerFactory {
        return iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    private func makeSingleAnswerQuestion(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> SingleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(
            for: singleAnswerQuestion,
            answerCallback: answerCallback
        ) as? UIHostingController<SingleAnswerQuestion>
        return controller?.rootView
    }
    
    private func makeQuestionController(
        question: Question<String>,
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> QuestionViewController {
        let sut = makeSUT()
        let controller = sut.questionViewController(
            for: question,
            answerCallback: answerCallback
        ) as! QuestionViewController
        return controller
    }
    
    private func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let sut = makeSUT()
        let controller = sut.resultsViewController(for: correctAnswers) as! ResultsViewController
        let presenter = ResultsPresenter(
            userAnswers: correctAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        return (controller, presenter)
    }
}
