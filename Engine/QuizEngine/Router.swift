//
//  Router.swift
//  QuizEngine
//
//  Created by chihyin wang on 2020/7/4.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

public protocol Router {
    associatedtype QuestionType: Hashable
    associatedtype Answer
    
    func routeTo(question: QuestionType, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<QuestionType, Answer>)
}
