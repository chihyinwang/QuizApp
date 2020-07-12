//
//  DelegateSpy.swift
//  QuizEngineTests
//
//  Created by chihyin wang on 2020/7/12.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import QuizEngine

class DelegateSpy: QuizDelegate {
    typealias Question = String
    typealias Answer = String
    
    var questionsAsked: [Question] = []
    var answerCompletions: [(String) -> Void] = []
    
    var completedQuizzes: [[(String, String)]] = []
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        self.answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
}
