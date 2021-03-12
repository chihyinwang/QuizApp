//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {
    var headerLabel = UILabel()
    
    private(set) var summary = ""
    private(set) var answers: [PresentableAnswer] = []
    
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return generateCell(answer: answers[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerLabel
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
