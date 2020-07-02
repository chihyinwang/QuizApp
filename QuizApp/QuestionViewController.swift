//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by chihyin wang on 2020/7/2.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import UIKit

class QuestionViewController: UITableViewController {
    
    var headerLabel = UILabel()
    private var question: String = ""
    private var options: [String] = []
    private let reuseIdentifier = "Cell"
    
    convenience init(question: String, options: [String]) {
        self.init()
        self.question = question
        self.options = options
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = question
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
}
