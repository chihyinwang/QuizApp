//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation
import XCTest

class ScoreTest: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: []), 0)
    }
    
    private class BasicScore {
        static func score(for: [Any]) -> Int {
            return 0
        }
    }
}
 
