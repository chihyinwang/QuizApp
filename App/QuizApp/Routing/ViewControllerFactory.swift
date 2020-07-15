//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answers: [String])]
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    
    func resultViewController(for userAnswers: Answers) -> UIViewController
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}

extension ViewControllerFactory {
    func resultViewController(for userAnswers: Answers) -> UIViewController {
        return UIViewController()
    }
}
