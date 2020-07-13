//
//  BasicScore.swift
//  QuizApp
//
//  Created by chihyin wang on 2020/7/13.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

final class BasicScore {
    static func score(for answers: [String], comparingTo correctAnswers: [String] = []) -> Int {
        return zip(answers, correctAnswers).reduce(0) { score, tuple in
            return score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
}
