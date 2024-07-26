//
//  CustomTextField.swift
//  RemindersClone
//
//  Created by Vahan on 23/07/2024.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if !text.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .padding()
                        .foregroundStyle(.secondary)
                    }
                }
            }
    }
}

extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(text: text))
    }
}

struct CustomTextField: View {
    let textEmplacement: String
    @Binding var text: String
    
    let width: CGFloat
    
    init(_ textEmplacement: String, text: Binding<String>, width: CGFloat = 320) {
        self.textEmplacement = textEmplacement
        self._text = text
        self.width = width
    }
    
    var body: some View {
        TextField(textEmplacement, text: $text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(.rect(cornerRadius: 15))
            .frame(
                maxWidth: width,
                alignment: .center
            )
    }
}

#Preview {
    @State var text: String = ""
    
    return CustomTextField("Enter a text", text: $text)
        .showClearButton($text)
}
