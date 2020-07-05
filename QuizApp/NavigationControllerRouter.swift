//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by chihyin wang on 2020/7/4.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController
    
    func resultViewController(for result: Result<Question<String>, String>) -> UIViewController
}

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func routeTo(question: Question<String>, answerCallback: @escaping AnswerCallback) {
        show(factory.questionViewController(question: question, answerCallback: answerCallback))
    }
    
    func routeTo(result: Result<Question<String>, String>) {
        show(factory.resultViewController(for: result))
    }
    
    func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
