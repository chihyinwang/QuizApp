//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import XCTest

struct BasicQuiz {
    
}

struct BasicQuizBuilder {
    
    func build() -> BasicQuiz? {
        nil
    }
}

class BasicQuizBuilderTests: XCTestCase {
    
    func test_empty() {
        let sut = BasicQuizBuilder()
        
        XCTAssertNil(sut.build())
    }
    
}
