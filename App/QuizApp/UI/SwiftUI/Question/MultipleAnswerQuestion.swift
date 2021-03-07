//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import SwiftUI

struct MultipleAnswerQuestion: View {
    let title: String
    let question: String
    @State var store: MultipleSelectionStore

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            QuestionHeader(title: title, question: question)
            
            ForEach(store.options.indices) { index in
                MultipleTextSelectionCell(option: $store.options[index])
            }
            
            Spacer()
            
            RoundedButton(
                title: "Submit",
                isEnabled: store.canSubmit,
                action: store.submit
            )
            .padding()
        }
    }
}

struct MultipleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultipleAnswerQuestionTestView()
            
            MultipleAnswerQuestionTestView()
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
    
    struct MultipleAnswerQuestionTestView: View {
        @State var selection: [String] = ["none"]
        
        var body: some View {
            VStack {
                MultipleAnswerQuestion(
                    title: "1 of 2",
                    question: "What's Bill's favorite color?",
                    store: .init(
                        options: [
                            "Maroon",
                            "Navy",
                            "Black",
                            "Pink",
                            "Dark green"
                        ], handler: { selection = $0 }
                ))
                
                Text("Last submission " + selection.joined(separator: ", "))
            }
        }
    }
}
