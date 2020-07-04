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
    
    let navigationController = UINavigationController()
    let factory = ViewControllerFactoryStub()
    
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    func test_routeToQuestion_showsQuestionController() {
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: "Q1", with: firstViewController)
        factory.stub(question: "Q2", with: secondViewController)
        
        sut.routeTo(question: "Q1", answerCallback: { _ in })
        sut.routeTo(question: "Q2", answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_showsQuestionControllerWithRightCallback() {
        var callbackWasFired = false
        sut.routeTo(question: "Q1", answerCallback: { _ in callbackWasFired = true })
        
        factory.answerCallback["Q1"]!("Anything")
        
        XCTAssertTrue(callbackWasFired)
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedViewController = [String: UIViewController]()
        var answerCallback = [String: (String) -> Void]()
        
        func stub(question: String, with viewController: UIViewController) {
            stubbedViewController[question] = viewController
        }
        
        func questionViewController(question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedViewController[question] ?? UIViewController()
        }
        
    }
    
    
}
