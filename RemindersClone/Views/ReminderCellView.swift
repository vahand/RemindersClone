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
    case onInfoSelected(Reminder)
}

struct ReminderCellView: View {
    let reminder: Reminder
    let isSelected: Bool
    let onEvent: (ReminderCellEvents) -> Void
    @State private var checked: Bool = false
    
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
                Text(reminder.title)
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
                        Text(reminderDate.formatted())
                    }
                    
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime.formatted())
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
            Image(systemName: "info.circle")
                .opacity(isSelected ? 1 : 0)
                .onTapGesture {
                    onEvent(.onInfoSelected(reminder))
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onEvent(.onSelect(reminder))
        }
    }
}

struct ReminderCellViewContainer: View {
    @Query(sort: \Reminder.title) private var reminders: [Reminder]
    
    var body: some View {
        ReminderCellView(reminder: reminders[0], isSelected: false) { _ in
        }
    }
}

#Preview { @MainActor in // since previewContainer is async
    ReminderCellViewContainer()
        .modelContainer(previewContainer)
}
