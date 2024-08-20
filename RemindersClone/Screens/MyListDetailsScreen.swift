//
//  MyListDetailsScreen.swift
//  RemindersClone
//
//  Created by Vahan on 25/07/2024.
//

import SwiftUI
import SwiftData

struct MyListDetailsScreen: View {
    @AppStorage("listStyle") private var isListPlain: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var isNewReminderPresented: Bool = false
    
    @State private var isListInfoPresented: Bool = false
    @State private var viewAsColumn: Bool = false
    
    @State private var selectedReminder: Reminder?
    @State private var showReminderEditScreen: Bool = false
    
    let myList: MyList
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private func saveReminder() {
        let reminder = Reminder(title: title)
        myList.reminders.append(reminder)
        title = ""
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        reminder.persistentModelID == selectedReminder?.persistentModelID
    }
    
    var body: some View {
        VStack {
            List {
                Text(myList.name)
                    .font(.system(.largeTitle, design: .rounded))
                    .listRowSeparator(.hidden)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(hex: myList.colorCode))
                ForEach(myList.reminders) { reminder in
                    ReminderCellView(reminder: reminder, isSelected: isReminderSelected(reminder)) { event in
                        switch event {
                        case .onChecked(let reminder, let checked):
                            reminder.isCompleted = checked
                        case .onSelect(let reminder):
                            selectedReminder = reminder
                        case .onInfoSelected(let reminder):
                            showReminderEditScreen = true
                            selectedReminder = reminder
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isListInfoPresented, content: {
            NavigationStack {
                AddMyListScreen(selectedColor: Color(hex: myList.colorCode), listName: myList.name, selectedSymbol: myList.symbol)
            }
        })
        .sheet(isPresented: $showReminderEditScreen, content: {
            if let selectedReminder {
                NavigationStack {
                    ReminderEditScreen(reminder: selectedReminder)
                }
            }
        })
        .myListStyle(isListPlain: !viewAsColumn)
        .listRowSpacing(viewAsColumn ? 8 : 0)
        .alert("New Reminder", isPresented: $isNewReminderPresented) {
            TextField("", text: $title)
            Button("Cancel", role: .cancel) {}
            Button("Done") {
                if isFormValid {
                    saveReminder()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left") // Back arrow image
                    .fontWeight(.semibold)
                Text("Lists") // Custom back button text
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Section {
                        Button {
                            viewAsColumn.toggle()
                        } label: {
                            if viewAsColumn {
                                HStack {
                                    Text("View as List")
                                    Spacer()
                                    Image(systemName: "list.dash")
                                }
                            } else {
                                HStack {
                                    Text("View as Columns")
                                    Spacer()
                                    Image(systemName: "tablecells.fill")
                                }
                            }
                        }
                    }
                    Button {
                        isListInfoPresented = true
                    } label: {
                        HStack {
                            Text("Show List Info")
                            Image(systemName: "info.circle")
                        }
                    }

                } label: {
                    Image(systemName: "ellipsis.circle")
                }

            }
            
            ToolbarItem(placement: .bottomBar) {
                Button {
                    isNewReminderPresented = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Reminder")
                    }
                    .foregroundStyle(Color(hex: myList.colorCode))
                    .fontWeight(.bold)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            }
        }
    }
}

struct MyListDetailsScreenContainer: View { // only created to render the preview
    @Query private var lists: [MyList]
    
    var body: some View {
        MyListDetailsScreen(myList: lists[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListDetailsScreenContainer()
            .modelContainer(previewContainer)
    }
}
