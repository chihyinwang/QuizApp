//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import QuizEngine

let demoQuiz = try!
    BasicQuizBuilder(
        singleAnswerQuestion: "What's Mike's nationality?",
        options: .init(head: "Canadian", tail: ["American", "Greek"]),
        answer: "Greek"
    )
    .adding(
        multipleAnswerQuestion: "What are Caio's nationalities?",
        options: .init(head: "Portuguese", tail: ["American", "Brazilian"]),
        answer: .init(head: "Portuguese", tail: ["Brazilian"])
    )
    .adding(
        singleAnswerQuestion: "What's the capital of Brazil?",
        options: .init(head: "Sao Paulo", tail: ["Rio de Janeiro", "Brasilia"]),
        answer: "Brasilia"
    )
    .build()
