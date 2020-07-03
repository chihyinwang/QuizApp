//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by chihyin wang on 2020/7/3.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit

struct PresentableAnswer {
    var isCorrect: Bool
}

class CorrectAnswerCell: UITableViewCell {
    
}

class WrongAnswerCell: UITableViewCell {
    
}

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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return answers[indexPath.row].isCorrect ? CorrectAnswerCell() : WrongAnswerCell()
    }
}
