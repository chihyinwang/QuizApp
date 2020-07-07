//
//  extensions.swift
//  QuizApp
//
//  Created by chihyin wang on 2020/7/3.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        let className = cellType.className
        if Bundle.main.path(forResource: className, ofType: "nib") != nil {
            // register for nib
            let nib = UINib(nibName: className, bundle: nil)
            register(nib, forCellReuseIdentifier: className)
        } else {
            // register for class
            register(cellType, forCellReuseIdentifier: className)
        }
    }
    
    func register<T: UITableViewCell>(_ cellTypes: [T.Type]) {
        cellTypes.forEach { register($0) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.className) as? T
    }
    
    func cellForRow<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T? {
        return cellForRow(at: indexPath) as? T
    }
}

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
    
}
