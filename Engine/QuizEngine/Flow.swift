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
    private var newAnswers: [(Question, Answer)] = []
    private var scoring: (([Question: Answer]) -> Int)
    
    init(questions: [Question], delegate: Delegate, scoring: @escaping (([Question: Answer]) -> Int) = { _ in 0 }) {
        self.questions = questions
        self.delegate = delegate
        self.scoring = scoring
    }
    
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    private func delegateQuestionHandling(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            delegate.answer(for: question, completion: answer(for: question, at: index))
        } else {
            delegate.didCompleteQuiz(withAnswers: newAnswers)
            delegate.handle(result: result())
        }
    }
    
    private func delegateQuestionHandling(after index: Int) {
        delegateQuestionHandling(at: questions.index(after: index))
    }
    
    private func answer(for question: Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.newAnswers.append((question, answer))
            self?.answers[question] = answer
            self?.delegateQuestionHandling(after: index)
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}
