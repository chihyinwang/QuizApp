//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import XCTest
import QuizEngine
@testable import QuizApp

class QuestionPresenterTest: XCTestCase {
    let question1 = Question.singleAnswer("Q1")
    let question2 = Question.multipleAnswer("Q2")
    
    func test_title_forFirstQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question1)
        
        XCTAssertEqual(sut.title, "1 of 2")
    }
    
    func test_title_forSecondQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)
        
        XCTAssertEqual(sut.title, "2 of 2")
    }
    
    func test_title_forUnexistQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [], question: Question.singleAnswer("Q1"))
        
        XCTAssertEqual(sut.title, "")
    }
}
