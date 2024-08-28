//
//  MyListDetailsScreen.swift
//  RemindersClone
//
//  Created by Vahan on 25/07/2024.
//

import SwiftUI
import SwiftData

struct MyListDetailsScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    
    @Query private var reminders: [Reminder]
    
    @State private var title: String = ""
    @State private var isNewReminderPresented: Bool = false
    
    @State private var isListInfoPresented: Bool = false
    
    let myList: MyList
    
    init(myList: MyList) {
        self.myList = myList
        
        let listId = myList.persistentModelID
        
        let predicate = #Predicate<Reminder> { reminder in // Predicate enable to filter reminders in the [Reminder] list depending on some conditions
            reminder.list?.persistentModelID == listId && !reminder.isCompleted
        }
        
        _reminders = Query(filter: predicate) // make a request to the Data base, based on the filter created with the Predicate
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private func saveReminder() {
        let reminder = Reminder(title: title)
        myList.reminders?.append(reminder)
        title = ""
    }
    
    var body: some View {
        ReminderListView(reminders: reminders, listTitle: myList.name, listColor: Color(hex: myList.colorCode))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(myList.name)
            .listStyle(.plain)
            .sheet(isPresented: $isListInfoPresented, content: {
                NavigationStack {
                    AddMyListScreen(myList: myList)
                }
            })
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
