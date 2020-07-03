//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by chihyin wang on 2020/7/3.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {
    private var summary = ""
    private var answers: [PresentableAnswer] = []
    
    var headerLabel = UILabel()
    
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = summary
        tableView.register(CorrectAnswerCell.self)
        tableView.register(WrongAnswerCell.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return generateCell(answer: answers[indexPath.row])
    }
    
    func generateCell(answer: PresentableAnswer) -> UITableViewCell {
        if answer.wrongAnswer == nil {
            let cell = tableView.dequeueReusableCell(CorrectAnswerCell.self)!
            cell.questionLabel.text = answer.question
            cell.answerLabel.text = answer.answer
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(WrongAnswerCell.self)!
            cell.questionLabel.text = answer.question
            cell.correctAnswerLabel.text = answer.answer
            cell.wrongAnswerLabel.text = answer.wrongAnswer
            return cell
        }
    }
}
