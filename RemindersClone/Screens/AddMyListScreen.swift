//
//  AddMyListScreen.swift
//  RemindersClone
//
//  Created by Vahan on 22/07/2024.
//

import SwiftUI

struct AddMyListScreen: View {
    @State private var selectedColor: Color
    @State private var listName: String
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    init(selectedColor: Color = .red, listName: String = "") {
        self.selectedColor = selectedColor
        self.listName = listName
    }
    
    private var isFormValid: Bool {
        !listName.isEmptyOrWhitespace
    }
    
    var body: some View {
//        VStack {
//            VStack {
//                ListIconView(color: selectedColor, size: 80, iconName: "list.bullet")
//                CustomTextField("List Name", text: $listName)
//                    .foregroundStyle(selectedColor)
//                    .font(.system(size: 20))
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//                    .showClearButton($listName)
//            }
//            .padding()
//            .background(Color.gray
//                .opacity(0.2)
//                .clipShape(.rect(cornerRadius: 25))
//            )
//            ColorPickerView(selectedColor: $selectedColor)
//                .padding(18)
//                .background(Color.gray
//                    .opacity(0.2)
//                    .clipShape(.rect(cornerRadius: 25))
//                )
//        }
        List {
            VStack {
                ListIconView(color: selectedColor, size: 80, iconName: "list.bullet")
                CustomTextField("List Name", text: $listName)
                    .foregroundStyle(selectedColor)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .showClearButton($listName)
            }
            ColorPickerView(selectedColor: $selectedColor)
                .padding(8)
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
                    guard let hex = selectedColor.toHex() else {
                        return
                    }
                    let myList = MyList(name: listName, colorCode: hex)
                    context.insert(myList)
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
