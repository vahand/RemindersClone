//
//  ColorPickerView.swift
//  RemindersClone
//
//  Created by Vahan on 22/07/2024.
//

import SwiftUI

struct ColorCircle: View {
    @Binding var selectedColor: Color
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(color)
            Circle()
                .strokeBorder(selectedColor.toHex() == color.toHex() ? Color.gray : Color.clear, lineWidth: 3)
                .scaleEffect(CGSize(width: 1.25, height: 1.25))
        }
        .onTapGesture {
            selectedColor = color
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    
    let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .orange, .gray, .brown]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<4) { index in
                    ColorCircle(selectedColor: $selectedColor, color: colors[index])
                }
            }
            Spacer(minLength: 20)
            HStack {
                ForEach(4..<8) { index in
                    ZStack {
                        ColorCircle(selectedColor: $selectedColor, color: colors[index])
                    }
                }
            }
        }
        .frame(
            maxWidth: 320,
            maxHeight: 120
        )
    }
}

#Preview {
    @State var color: Color = .red
    return ColorPickerView(selectedColor: $color)
}
