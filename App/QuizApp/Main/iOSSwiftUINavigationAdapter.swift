//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import SwiftUI
import UIKit
import QuizEngine

final class iOSSwiftUINavigationAdapter: QuizDelegate {
    typealias Question = QuizEngine.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let navigation: UINavigationController
    private let options: Dictionary<Question, Answer>
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    
    private var questions: [Question] {
        return correctAnswers.map { $0.question }
    }
    
    init(navigation: UINavigationController, options: Dictionary<Question, Answer>, correctAnswers: Answers, playAgain: @escaping () -> Void) {
        self.navigation = navigation
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        show(questionViewController(for: question, answerCallback: completion))
    }
    
    func didCompleteQuiz(withAnswers answers: Answers) {
        show(resultsViewController(for: answers))
    }
    
    private func show(_ controller: UIViewController) {
        navigation.setViewControllers([controller], animated: true)
    }
    
    private func questionViewController(for question: Question, answerCallback: @escaping (Answer) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for quesiton")
        }
        
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question, options: Answer, answerCallback: @escaping (Answer) -> Void) -> UIViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        
        switch question {
        case .singleAnswer(let value):
            return UIHostingController(
                rootView: SingleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    options: options,
                    selection: { answerCallback([$0]) }))
            
        case .multipleAnswer(let value):
            return UIHostingController(
                rootView: MultipleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    store: .init(options: options, handler: answerCallback)))
        }
    }
    
    private func questionViewController(question: Question, questionValue: String, options: Answer, allowsMultipleSelection: Bool, answerCallback: @escaping (Answer) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: questionValue, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }
    
    private func resultsViewController(for answers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(userAnswers: answers,
                                         correctAnswers: correctAnswers,
                                         scorer: BasicScore.score)
        
        return UIHostingController(
            rootView: ResultView(
                title: presenter.title,
                summary: presenter.summary,
                answers: presenter.presentableAnswers,
                playAgain: playAgain))
    }
}
