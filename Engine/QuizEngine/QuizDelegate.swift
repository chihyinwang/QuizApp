//
//  QuizDelegate.swift
//  QuizEngine
//
//  Created by chihyin wang on 2020/7/10.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

public protocol QuizDelegate {
    associatedtype QuestionType: Hashable
    associatedtype Answer
    
    func answer(for question: QuestionType, completion: @escaping (Answer) -> Void)
    
    func didCompleteQuiz(withAnswers answers: [(question: QuestionType, answer: Answer)])
}
