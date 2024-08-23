//
//  AddMyListScreen.swift
//  RemindersClone
//
//  Created by Vahan on 22/07/2024.
//

import SwiftUI

struct AddMyListScreen: View {
    @State private var selectedColor: Color = .red
    @State private var listName: String = ""
    @State private var selectedSymbol: String = "list.bullet"
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var myList: MyList? = nil
    
    private var isFormValid: Bool {
        !listName.isEmptyOrWhitespace
    }
    
    var body: some View {
        List {
            VStack {
                ListIconView(color: selectedColor, size: 80, iconName: selectedSymbol)
                CustomTextField("List Name", text: $listName)
                    .foregroundStyle(selectedColor)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .showClearButton($listName)
            }
            ColorPickerView(selectedColor: $selectedColor)
                .padding(8)
            SymbolsPickerView(systemName: $selectedSymbol)
        }
        .onAppear() {
            if let myList {
                listName = myList.name
                selectedColor = Color(hex: myList.colorCode)
                selectedSymbol = myList.symbol
            }
        }
        .listRowSpacing(15)
        .navigationTitle("New List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if let myList {
                        myList.name = listName
                        myList.colorCode = selectedColor.toHex() ?? ""
                        myList.symbol = selectedSymbol
                    } else {
                        guard let hex = selectedColor.toHex() else { return }
                        
                        let myList = MyList(name: listName, colorCode: hex, symbol: selectedSymbol)
                        context.insert(myList)
                    }
                    
                    dismiss()
                } label: {
                    Text("Done")
                }
                .disabled(!isFormValid)
            }
        }
    }
}

#Preview { @MainActor in //'@MainActor' means that code runs on the main thread
    NavigationStack {
        AddMyListScreen()
    }.modelContainer(previewContainer)
}
