//
//  QuestionTest.swift
//  QuizEngineTests
//
//  Created by chihyin wang on 2020/7/7.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class QuestionTest: XCTestCase {
    
    func test_hashValue_singleAnswer_returnsTypeHash() {
        
        let type = "A String"
        
        let sut = Question.singleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_hashValue_multipleAnswer_returnsTypeHash() {
        
        let type = "A String"
        
        let sut = Question.multipleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_equal_isEqual() {
        XCTAssertEqual(Question.singleAnswer("A String"), Question.singleAnswer("A String"))
        XCTAssertEqual(Question.multipleAnswer("A String"), Question.multipleAnswer("A String"))
    }
    
    func test_equal_isNotEqual() {
        XCTAssertNotEqual(Question.singleAnswer("A String"), Question.singleAnswer("Another String"))
        XCTAssertNotEqual(Question.multipleAnswer("A String"), Question.multipleAnswer("Another String"))
        XCTAssertNotEqual(Question.singleAnswer("A String"), Question.multipleAnswer("Another String"))
        XCTAssertNotEqual(Question.singleAnswer("A String"), Question.multipleAnswer("A String"))
    }
    
}
