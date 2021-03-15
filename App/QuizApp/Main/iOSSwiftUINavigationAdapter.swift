//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import SwiftUI
import UIKit
import QuizEngine

class QuizNavigationStore: ObservableObject {
    enum CurrentView {
        case single(SingleAnswerQuestion)
        case multiple(MultipleAnswerQuestion)
        case result(ResultView)
    }
    
    @Published var currentView: CurrentView?
}

final class iOSSwiftUINavigationAdapter: QuizDelegate {
    typealias Question = QuizEngine.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let navigation: QuizNavigationStore
    private let options: Dictionary<Question, Answer>
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    
    private var questions: [Question] {
        return correctAnswers.map { $0.question }
    }
    
    init(navigation: QuizNavigationStore, options: Dictionary<Question, Answer>, correctAnswers: Answers, playAgain: @escaping () -> Void) {
        self.navigation = navigation
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for quesiton")
        }
        
        let presenter = QuestionPresenter(questions: questions, question: question)
        
        switch question {
        case .singleAnswer(let value):
            navigation.currentView = .single(
                SingleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    options: options,
                    selection: { completion([$0]) }))
            
        case .multipleAnswer(let value):
            navigation.currentView = .multiple(
                MultipleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    store: .init(options: options, handler: completion)))
        }
    }
    
    func didCompleteQuiz(withAnswers answers: Answers) {
        let presenter = ResultsPresenter(userAnswers: answers,
                                         correctAnswers: correctAnswers,
                                         scorer: BasicScore.score)
        
        navigation.currentView = .result(
            ResultView(
                title: presenter.title,
                summary: presenter.summary,
                answers: presenter.presentableAnswers,
                playAgain: playAgain))
    }
}
