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
    
    func test_routeToQuestion_presentsQuestionController() {
        let navigationController = UINavigationController()
        let factory = ViewControllerFactoryStub()
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: "Q1", with: firstViewController)
        factory.stub(question: "Q2", with: secondViewController)
        
        let sut = NavigationControllerRouter(navigationController, factory: factory)
        
        sut.routeTo(question: "Q1", answerCallback: { _ in })
        sut.routeTo(question: "Q2", answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        var stubbedViewController = [String: UIViewController]()
        
        func stub(question: String, with viewController: UIViewController) {
            stubbedViewController[question] = viewController
        }
        
        func questionViewController(question: String, answerCallback: (String) -> Void) -> UIViewController {
            return stubbedViewController[question]!
        }
        
    }
    
    
}
