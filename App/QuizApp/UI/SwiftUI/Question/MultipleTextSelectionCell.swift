//
// Copyright © 2021 chihyinwang. All rights reserved.
//

import SwiftUI

struct MultipleTextSelectionCell: View {
    @Binding var option: MultipleSelectionOption
    
    var body: some View {
        Button(action: { option.toggleSelection() }, label: {
            HStack {
                Rectangle()
                    .strokeBorder(option.isSelected ? Color.blue : .secondary, lineWidth: 2.5)
                    .overlay(
                        Rectangle()
                            .fill(option.isSelected ? Color.blue : .clear)
                            .frame(width: 26, height: 26)
                    )
                    .frame(width: 40.0, height: 40.0)
                
                Text(option.text)
                    .font(.title)
                    .foregroundColor(Color.secondary)
                
                Spacer()
            }.padding()
        })
    }
}

struct MultipleTextSelectionCell_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextSelectionCell(
            option: .constant(.init(text: "A text", isSelected: false))
        ).previewLayout(.sizeThatFits)
        
        MultipleTextSelectionCell(
            option: .constant(.init(text: "A text", isSelected: true))
        ).previewLayout(.sizeThatFits)
    }
}
