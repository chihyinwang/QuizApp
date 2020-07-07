//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
