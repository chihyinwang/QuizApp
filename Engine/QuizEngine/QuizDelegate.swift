//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

public protocol QuizDelegate {
    associatedtype Question
    associatedtype Answer
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    
    func didCompleteQuiz(withAnswers answers: [(question: Question, answer: Answer)])
}
