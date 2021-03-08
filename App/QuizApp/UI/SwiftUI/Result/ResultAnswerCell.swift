//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import SwiftUI

struct ResultAnswerCell: View {
    let model: PresentableAnswer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(model.question)
                .font(.title)
            
            Text(model.answer)
                .font(.headline)
                .foregroundColor(.green)
            
            if let wrongAnswer = model.wrongAnswer {
                Text(wrongAnswer)
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }.padding(.vertical)
    }
}


struct ResultAnswerCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultAnswerCell(model: .init(question: "A question", answer: "A correctAnswer", wrongAnswer: "A wrong Answer"))
                .previewLayout(.sizeThatFits)
            
            ResultAnswerCell(model: .init(question: "A question", answer: "A correctAnswer", wrongAnswer: nil))
                .previewLayout(.sizeThatFits)
        }
    }
}
