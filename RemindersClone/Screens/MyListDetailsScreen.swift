//
//  MyListDetailsScreen.swift
//  RemindersClone
//
//  Created by Vahan on 25/07/2024.
//

import SwiftUI
import SwiftData

struct MyListDetailsScreen: View {
    //    @AppStorage("listStyle") private var isListPlain: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    
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
    
    private func deleteReminder(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let reminder = myList.reminders[index]
        context.delete(reminder)
    }
    
    var body: some View {
        ReminderListView(reminders: myList.reminders.filter { !$0.isCompleted }, listTitle: myList.name, listColor: Color(hex: myList.colorCode))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(myList.name)
            .listStyle(.plain)
            .sheet(isPresented: $isListInfoPresented, content: {
                NavigationStack {
                    AddMyListScreen(myList: myList)
                }
            })
            .sheet(isPresented: $showReminderEditScreen, content: {
                if let selectedReminder {
                    NavigationStack {
                        ReminderEditScreen(reminder: selectedReminder)
                    }
                }
            })
            .listRowSpacing(viewAsColumn ? 8 : 0)
            .alert("New Reminder", isPresented: $isNewReminderPresented) {
                TextField("", text: $title)
                Button("Cancel", role: .cancel) {}
                Button("Done") {
                    if isFormValid {
                        saveReminder()
                        title = ""
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
