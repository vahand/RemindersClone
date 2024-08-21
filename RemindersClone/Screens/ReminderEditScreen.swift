//
//  ReminderEditScreen.swift
//  RemindersClone
//
//  Created by Vahan on 26/07/2024.
//

import SwiftUI
import SwiftData

struct ReminderEditScreen: View {
    let reminder: Reminder
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var reminderDate: Date = .now
    @State private var reminderTime: Date = .now
    
    @State private var showCalendar: Bool = false
    @State private var showTime: Bool = false
    
    private func updateReminder() {
        reminder.title = title
        reminder.notes = notes.isEmpty ? nil : notes
        
        // bad approch right here
        reminder.reminderDate = showCalendar ? reminderDate : nil
        reminder.reminderTime = showTime ? reminderTime : nil
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Notes", text: $notes)
            }
            Section {
                HStack {
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .clipShape(.rect(cornerRadius: 5))
                        .foregroundStyle(.red)
                        .overlay {
                            Image(systemName: "calendar")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        .padding(.trailing, 5)
                    Toggle(isOn: $showCalendar, label: {
                        Text("Date")
                    })
                }
                .onChange(of: showCalendar) {
                    if !showCalendar {
                        showTime = false
                    }
                }
                if showCalendar {
                    DatePicker("Date", selection: $reminderDate, in: .now..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                HStack {
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .clipShape(.rect(cornerRadius: 5))
                        .foregroundStyle(.blue)
                        .overlay {
                            Image(systemName: "clock.fill")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        .padding(.trailing, 5)
                    Toggle(isOn: $showTime, label: {
                        Text("Time")
                    })
                }
                .onChange(of: showTime) {
                    if showTime {
                        showCalendar = true
                    }
                }
                if showTime {
                    DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                }
            }
        }.onAppear(perform: {
            title = reminder.title
            notes = reminder.notes ?? ""
            reminderDate = reminder.reminderDate ?? Date()
            reminderTime = reminder.reminderTime ?? Date()
            showCalendar = reminder.reminderDate != nil
            showTime = reminder.reminderTime != nil
        })
        .navigationTitle("Details")
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
                    updateReminder()
                    dismiss()
                } label: {
                    Text("Done")
                }
                .disabled(!isFormValid)
            }
        }
    }
}

struct ReminderEditScreenContainer: View {
    @Query private var reminders: [Reminder]
    
    var body: some View {
        ReminderEditScreen(reminder: reminders[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        ReminderEditScreenContainer()
    }.modelContainer(previewContainer)
}
