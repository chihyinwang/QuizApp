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
    
    public static func start<Delegate: QuizDelegate>(questions: [Delegate.QuestionType], delegate: Delegate, correctAnswer: [Delegate.QuestionType: Delegate.Answer]) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(questions: questions, delegate: delegate, scoring: { scoring($0, correctAnswer: correctAnswer) })
        flow.start()
        return Quiz(flow: flow)
    }
}

func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswer: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
    }
}
