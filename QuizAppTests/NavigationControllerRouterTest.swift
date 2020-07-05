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
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    func test_routeToQuestion_showsQuestionController() {
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), with: firstViewController)
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in })
        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_showsQuestionControllerWithRightCallback() {
        var callbackWasFired = false
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in callbackWasFired = true })
        
        factory.answerCallback[Question.singleAnswer("Q1")]!("Anything")
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showsResultController() {
        let viewController = UIViewController()
        let result = Result(answers: [Question.singleAnswer("Q1"): "A1"], score: 10)
        
        factory.stub(result: result, with: viewController)
        sut.routeTo(result: result)
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
    }
    
    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = Dictionary<Question<String>, UIViewController>()
        private var stubbedResults = Dictionary<Result<Question<String>, String>, UIViewController>()
        var answerCallback = Dictionary<Question<String>, (String) -> Void>()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(result: Result<Question<String>, String>, with viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        
        func questionViewController(question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, String>) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
        
    }
    
    
}

extension Result: Hashable {
    
    // fake hashable for testing (Result in dictionary)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
    
    public static func ==(lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
