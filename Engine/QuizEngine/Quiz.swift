//
//  Quiz.swift
//  QuizEngine
//
//  Created by chihyin wang on 2020/7/10.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

public final class Quiz {
    private let flow: Any
    
    private init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(questions: [Question], delegate: Delegate, correctAnswer: [Question: Answer]) -> Quiz where Delegate.QuestionType == Question, Delegate.Answer == Answer {
        let flow = Flow(questions: questions, delegate: delegate, scoring: { scoring($0, correctAnswer: correctAnswer) })
        flow.start()
        return Quiz(flow: flow)
    }
}
