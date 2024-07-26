//
//  PreviewContainer.swift
//  RemindersClone
//
//  Created by Vahan on 23/07/2024.
//

import Foundation
import SwiftData

@MainActor
var previewContainer: ModelContainer = {
    let container = try! ModelContainer(for: MyList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for list in SampleData.lists {
        container.mainContext.insert(list)
        list.reminders = SampleData.reminders
    }
    
    return container
}()

struct SampleData {
    static var lists: [MyList] {
        return [MyList(name: "ForToday", colorCode: "#2ecc71"), MyList(name: "Entertainment", colorCode: "#9b59b6")]
    }
    
    static var reminders: [Reminder] {
        return [Reminder(title: "Reminder 1", notes: "This is reminder 1 notes", reminderDate: Date(), reminderTime: Date()), Reminder(title: "Reminder 2", notes: "This is a reminder 2 note", reminderDate: Date())]
    }
}
