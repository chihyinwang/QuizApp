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
    
    func handle(question: QuestionType, answerCallback: @escaping (Answer) -> Void)
    func handle(result: Result<QuestionType, Answer>)
}