//
//  Game.swift
//  QuizEngine
//
//  Created by chihyin wang on 2020/7/4.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

@available(*, deprecated)
public protocol Router {
    associatedtype QuestionType: Hashable
    associatedtype Answer
    
    func routeTo(question: QuestionType, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<QuestionType, Answer>)
}

@available(*, deprecated)
public class Game <Question, Answer, R: Router> {
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswer: [Question: Answer]) -> Game<Question, Answer, R> where R.QuestionType == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router, correctAnswer))
    flow.start()
    return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate where R.Answer: Equatable {
    private let router: R
    private let correctAnswers: [R.QuestionType: R.Answer]
    
    init(_ router: R, _ correctAnswers: [R.QuestionType: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }
    
    func answer(for question: R.QuestionType, completion: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: R.QuestionType, answer: R.Answer)]) {
        let answerDictionary = answers.reduce([R.QuestionType: R.Answer]()) { acc, tuple in
            var acc = acc
            acc[tuple.question] = tuple.answer
            return acc
        }
        
        let score = scoring(answerDictionary, correctAnswer: correctAnswers)
        let result = Result(answers: answerDictionary, score: score)
        router.routeTo(result: result)
    }
    
    func handle(result: Result<R.QuestionType, R.Answer>) {}
    
    private func scoring(_ answers: [R.QuestionType: R.Answer], correctAnswer: [R.QuestionType: R.Answer]) -> Int {
        return answers.reduce(0) { (score, tuple) in
            return score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
        }
    }
}
