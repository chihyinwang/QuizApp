//
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
}
