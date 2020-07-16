//
//  NavigationControllerRouterTest.swift
//  QuizAppTests
//
//  Created by chihyin wang on 2020/7/4.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {
    
    func test_answerForQuestion_showsQuestionController() {
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: firstViewController)
        factory.stub(question: multipleAnswerQuestion, with: secondViewController)
        
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_answerForQuestion_singleAnswer_answerCallback_progressToNextQuestion() {
        var callbackWasFired = false
        sut.answer(for: singleAnswerQuestion, completion: { _ in callbackWasFired = true })
        
        factory.answerCallback[singleAnswerQuestion]!(["Anything"])
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_answerForQuestion_singleAnswer_doesNotConfigureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipeleAnswer_answerCallback_doesNotProgressToNextQuestion() {
        var callbackWasFired = false
        sut.answer(for: multipleAnswerQuestion, completion: { _ in callbackWasFired = true })
        
        factory.answerCallback[multipleAnswerQuestion]!(["Anything"])
        
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_answerForQuestion_multipeleAnswer_configureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipeleAnswerSubmitButton_isDisabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_answerForQuestion_multipeleAnswerSubmitButton_progressToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        var callbackWasFired = false
        sut.answer(for: multipleAnswerQuestion, completion: { _ in callbackWasFired = true })
        
        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_didCompleteQuiz_showsResultController() {
        let viewController = UIViewController()
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        
        let secondViewController = UIViewController()
        let secondUserAnswers = [(multipleAnswerQuestion, ["A2"])]
        
        factory.stub(resultForQuestions: [singleAnswerQuestion], with: viewController)
        factory.stub(resultForQuestions: [multipleAnswerQuestion], with: secondViewController)
        
        sut.didCompleteQuiz(withAnswers: userAnswers)
        sut.didCompleteQuiz(withAnswers: secondUserAnswers)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    // MARK: - Helpers
    
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    
    private let navigationController = NonAnimatedNavigationController()
    private let factory = ViewControllerFactoryStub()
    
    private lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    private class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    private class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubbedQuestions = Dictionary<Question<String>, UIViewController>()
        private var stubbedResults = Dictionary<[Question<String>], UIViewController>()
        var answerCallback = Dictionary<Question<String>, ([String]) -> Void>()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(resultForQuestions questions: [Question<String>], with viewController: UIViewController) {
            stubbedResults[questions] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for userAnswers: Answers) -> UIViewController {
            return stubbedResults[userAnswers.map { $0.question }] ?? UIViewController()
        }
        
    }
    
}

private extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
