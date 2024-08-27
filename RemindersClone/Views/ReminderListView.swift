//
//  ReminderListView.swift
//  RemindersClone
//
//  Created by Vahan on 25/08/2024.
//

import SwiftUI
import SwiftData

struct ReminderListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    
    @State private var selectedReminder: Reminder?
    @State private var showReminderEditScreen: Bool = false
    
    let reminders: [Reminder]
    
    @State var listTitle: String
    @State var listColor: Color
        
    @State private var reminderIdAndDelay: [PersistentIdentifier: Delay] = [:] // a dictionnary
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        reminder.persistentModelID == selectedReminder?.persistentModelID
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let reminder = reminders[index]
        context.delete(reminder)
    }
    
    var body: some View {
        List {
            Text(listTitle)
                .font(.system(.largeTitle, design: .rounded))
                .listRowSeparator(.hidden)
                .fontWeight(.bold)
                .foregroundStyle(listColor)
            Section {
                ForEach(reminders) { reminder in
                    // add "show completed" section button
                    ReminderCellView(reminder: reminder) { event in
                        switch event {
                        case .onChecked(let reminder, let checked):
                            // get the delay from the dict
                            var delay = reminderIdAndDelay[reminder.persistentModelID] // give the delat linked to the reminder
                            if let delay {
                                // cancel the current work
                                delay.cancel()
                                // remove the delay from the dict
                                reminderIdAndDelay.removeValue(forKey: reminder.persistentModelID)
                            } else {
                                // create a new delay and add it to the dict
                                delay = Delay()
                                reminderIdAndDelay[reminder.persistentModelID] = delay
                                delay?.performWork {
                                    reminder.isCompleted = checked
                                }
                            }

                        case .onSelect(let reminder):
                            showReminderEditScreen = true
                            selectedReminder = reminder
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteReminder(indexSet)
                })
            }
            .listSectionSeparator(.hidden, edges: .top)
        }
        .sheet(isPresented: $showReminderEditScreen, content: {
            if let selectedReminder {
                NavigationStack {
                    ReminderEditScreen(reminder: selectedReminder)
                }
            }
        })
    }
}

struct ReminderListViewContainer: View {
    @Query private var reminders: [Reminder]
    
    var body: some View {
        ReminderListView(reminders: reminders, listTitle: "ForToday", listColor: .red)
    }
}

#Preview { @MainActor in
    NavigationStack {
        ReminderListViewContainer()
            .modelContainer(previewContainer)
    }
}
