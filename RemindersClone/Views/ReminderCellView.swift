//
//  ReminderCellView.swift
//  RemindersClone
//
//  Created by Vahan on 26/07/2024.
//

import SwiftUI
import SwiftData

enum ReminderCellEvents {
    case onChecked(Reminder, Bool)
    case onSelect(Reminder)
    case cancelSelection
}

struct ReminderCellView: View {
    let reminder: Reminder
    let onEvent: (ReminderCellEvents) -> Void
    @State private var checked: Bool = false
    @State private var reminderTitle: String = ""
    
    init(reminder: Reminder, onEvent: @escaping (ReminderCellEvents) -> Void) {
        self.reminder = reminder
        self.onEvent = onEvent
        _reminderTitle = State(initialValue: reminder.title)
    }
    
    private func formatReminderDate(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    
    private func shareFocus(focused: Bool) {
        if focused {
            onEvent(.onSelect(reminder))
        } else {
            reminder.title = reminderTitle
            onEvent(.cancelSelection)
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: checked ? "circle.inset.filled" : "circle")
                .font(.title2)
                .padding(.trailing, 5)
                .foregroundStyle(checked ? Color(hex: reminder.list?.colorCode ?? "") : .gray)
                .onTapGesture {
                    // We don't call the database right now since user could check and uncheck many time in a second. It would be to many database request. There is a delay
                    checked.toggle()
                    onEvent(.onChecked(reminder, checked))
                }
            VStack {
                TextField("", text: $reminderTitle, onEditingChanged: shareFocus)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                if let notes = reminder.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                
                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(formatReminderDate(reminderDate))
                    }
                    
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime, style: .time)
                    }
                }
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            }
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct ReminderCellViewContainer: View {
    @Query(sort: \Reminder.title) private var reminders: [Reminder]
    
    var body: some View {
        ReminderCellView(reminder: reminders[0]) { _ in
        }
    }
}

#Preview { @MainActor in // since previewContainer is async
    ReminderCellViewContainer()
        .modelContainer(previewContainer)
}
