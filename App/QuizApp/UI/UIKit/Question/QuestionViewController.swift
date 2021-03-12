//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit

class QuestionViewController: UITableViewController {
    var headerLabel = UILabel()
    private(set) var question: String = ""
    private(set) var options: [String] = []
    private(set) var allowsMultipleSelection: Bool = false
    private var selection: (([String]) -> Void)? = nil
    private let reuseIdentifier = "Cell"
    
    convenience init(question: String, options: [String], allowsMultipleSelection: Bool, selection: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.allowsMultipleSelection = allowsMultipleSelection
        self.selection = selection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = allowsMultipleSelection
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectedOptions(in: tableView))
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOptions(in: tableView))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerLabel
    }
    
    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return [] }
        return indexPaths.map { options[$0.row] }
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
}
