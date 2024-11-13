//
//  Design.MarkupText.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.08.24.
//

import SwiftUI

struct Design_MarkupTextView: View {
    @State var text: String = ""
    
    var attributedString: AttributedString {
        (try? AttributedString(markdown: text)) ?? AttributedString("Oha")
    }
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter Markup Text", text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Text(attributedString)
        }
    }
}

#Preview {
    Design_MarkupTextView()
}
