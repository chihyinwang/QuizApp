//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    
    private let questions: [Question<String>]
    private let options: Dictionary<Question<String>, [String]>
    
    init(questions: [Question<String>], options: Dictionary<Question<String>, [String]>) {
        self.questions = questions
        self.options = options
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for quesiton")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return questionViewController(question: question, questionValue: value, options: options, answerCallback: answerCallback)
        case .multipleAnswer(let value):
            let controller = questionViewController(question: question, questionValue: value, options: options, answerCallback: answerCallback)
            _ = controller.view
            controller.tableView.allowsMultipleSelection = true
            return controller
        }
    }
    
    private func questionViewController(question: Question<String>, questionValue: String, options: [String], answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: questionValue, options: options, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
}
