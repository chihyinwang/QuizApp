//
//  Game.swift
//  QuizEngine
//
//  Created by chihyin wang on 2020/7/4.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

public class Game <Question, Answer, R: Router> where R.QuestionType == Question, R.Answer == Answer {
    let flow: Flow<Question, Answer, R>
    
    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswer: [Question: Answer]) -> Game<Question, Answer, R> where R.QuestionType == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, router: router, scoring: { scoring($0, correctAnswer: correctAnswer) })
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswer: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
    }
}
