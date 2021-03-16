//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import QuizEngine

let question1 = Question.singleAnswer("What's Bill's favorite color?")
let question2 = Question.multipleAnswer("What's Bill's favorite brand?")
let questions = [question1, question2]

let option101 = "Maroon"
let option102 = "Navy"
let option103 = "Black"
let options1 = [option101, option102, option103]

let option201 = "Maison Martin Margiela"
let option202 = "Christian Dior"
let option203 = "Raf Simons"
let option204 = "Haider Ackermann"
let options2 = [option201, option202, option203, option204]

let options = [question1: options1, question2: options2]
let correctAnswers = [(question1, [option103]), (question2, [option201, option202, option204])]
