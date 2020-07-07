//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by chihyin wang on 2020/7/2.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_rendersQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1", options: []).headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_rendersOptions() {
        XCTAssertEqual(makeSUT(question: "Q1").tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_rendersOptionsText() {
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.title(at: 1), "A2")
    }
    
    func test_viewDidLoad_configuresMultipleSelection() {
        XCTAssertFalse(makeSUT(allowsMultipleSelection: false).allowsMultipleSelection)
        XCTAssertTrue(makeSUT(allowsMultipleSelection: true).allowsMultipleSelection)
    }
    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var answer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { answer = $0 }
        
        sut.tableView.select(at: 0)
        XCTAssertEqual(answer, ["A1"])
        
        sut.tableView.select(at: 1)
        XCTAssertEqual(answer, ["A2"])
    }
    
    func test_optionDeselected_withSingleSelection_doesnotNotifiesDelegate() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { _ in callbackCount += 1 }

        sut.tableView.select(at: 0)
        XCTAssertEqual(callbackCount, 1)

        sut.tableView.deselect(at: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
        var answer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { answer = $0 }
        sut.tableView.allowsMultipleSelection = true
        
        sut.tableView.select(at: 0)
        XCTAssertEqual(answer, ["A1"])
        
        sut.tableView.select(at: 1)
        XCTAssertEqual(answer, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegate() {
        var answer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { answer = $0 }
        sut.tableView.allowsMultipleSelection = true
        
        sut.tableView.select(at: 0)
        XCTAssertEqual(answer, ["A1"])
        
        sut.tableView.deselect(at: 0)
        XCTAssertEqual(answer, [])
    }
    
    // MARK: - Helpers
    func makeSUT(question: String = "",
                 options: [String] = [],
                 allowsMultipleSelection: Bool = false,
                 selection: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: selection)
        _ = sut.view
        return sut
    }
    
}

