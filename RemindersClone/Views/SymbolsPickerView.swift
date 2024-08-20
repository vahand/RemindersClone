//
//  SymbolsPicker.swift
//  RemindersClone
//
//  Created by Vahan on 02/08/2024.
//

import SwiftUI

// enable to select a symbol from a list (all from SF Symbols app)
// 2 ways to provide the list:
// -> list as parameter
// -> name of a JSON file as parameter. This file contain all image systemName

struct SymbolCircle: View {
    @Binding var selectedSymbol: String
    let symbol: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color("listElemColor"))
                .overlay {
                    Image(systemName: symbol)
                        .fontWeight(.bold)
                }
                .frame(width: 40)
            Circle()
                .strokeBorder(selectedSymbol == symbol ? Color.gray : Color.clear, lineWidth: 3)
                .frame(width: 50)
                .scaleEffect(CGSize(width: 1.1, height: 1.1))
        }
        .onTapGesture {
            selectedSymbol = symbol
        }
    }
}

struct SymbolsPickerView: View {
    @Binding var systemName: String
    
    let symbols: [String] = ["list.bullet", "trash", "link", "person", "studentdesk", "book", "doc", "tray", "folder", "clipboard", "note", "calendar", "newspaper", "magazine", "bookmark", "graduationcap"]
    
    var body: some View {
        VStack {
            let rows = symbols.chunked(into: 6)
            
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { symbolName in
                        SymbolCircle(selectedSymbol: $systemName, symbol: symbolName)
                    }
                }
            }
        }
        .frame(
            maxWidth: 320
        )
        .padding(5)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    @State var image: String = "link"
    return SymbolsPickerView(systemName: $image)
}
