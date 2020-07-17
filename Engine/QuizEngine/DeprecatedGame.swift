//
//  Game.swift
//  QuizEngine
//
//  Created by chihyin wang on 2020/7/4.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "use QuizDelegate instead")
public protocol Router {
    associatedtype QuestionType: Hashable
    associatedtype Answer
    
    func routeTo(question: QuestionType, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<QuestionType, Answer>)
}

@available(*, deprecated, message: "scoring won't be supported in the future")
public struct Result <Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}

@available(*, deprecated, message: "use Quiz instead")
public class Game <Question, Answer, R: Router> {
    let quiz: Quiz
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
}

@available(*, deprecated, message: "use Quiz.start instead")
public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswer: [Question: Answer]) -> Game<Question, Answer, R> where R.QuestionType == Question, R.Answer == Answer {
    let adapter = QuizDelegateToRouterAdapter(router, correctAnswer)
    let quiz = Quiz.start(questions: questions, delegate: adapter)
    return Game(quiz: quiz)
}

@available(*, deprecated, message: "remove along with the deprecated Game types")
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
    
    private func scoring(_ answers: [R.QuestionType: R.Answer], correctAnswer: [R.QuestionType: R.Answer]) -> Int {
        return answers.reduce(0) { (score, tuple) in
            return score + (correctAnswer[tuple.key] == tuple.value ? 1 : 0)
        }
    }
}
