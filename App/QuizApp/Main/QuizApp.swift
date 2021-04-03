//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import SwiftUI
import QuizEngine

@main
struct QuizApp: App {
    @State var quiz: Quiz?
    @StateObject var navigationStore = QuizNavigationStore()

    var body: some Scene {
        WindowGroup {
            QuizNavigationView(store: navigationStore)
                .onAppear {
                    startNewQuiz()
                }
        }
    }

    private func startNewQuiz() {
        let adapter = iOSSwiftUINavigationAdapter(
            navigation: navigationStore,
            options: demoQuiz.options,
            correctAnswers: demoQuiz.correctAnswers,
            playAgain: startNewQuiz)

        quiz = Quiz.start(questions: demoQuiz.questions, delegate: adapter)
    }
}
