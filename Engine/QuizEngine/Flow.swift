//
//  Flow.swift
//  QuizEngine
//
//  Created by chihyin wang on 2020/6/26.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

class Flow <Delegate: QuizDelegate> {
    typealias Question = Delegate.QuestionType
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var scoring: (([Question: Answer]) -> Int)
    
    init(questions: [Question], router: Delegate, scoring: @escaping (([Question: Answer]) -> Int)) {
        self.questions = questions
        self.delegate = router
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            delegate.handle(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            delegate.handle(result: result())
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
        guard let currentQuestionIndex = questions.lastIndex(of: question) else {return}
        
        answers[question] = answer
        let nextQuestionIndex = currentQuestionIndex+1
        if nextQuestionIndex < questions.count {
            let nextQuestion = questions[nextQuestionIndex]
            delegate.handle(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
        } else {
            delegate.handle(result: result())
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}
