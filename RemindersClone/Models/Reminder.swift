//
//  Reminder.swift
//  RemindersClone
//
//  Created by Vahan on 25/07/2024.
//

import Foundation
import SwiftData

@Model // since this model is persited to the database. can only be applied to a class
class Reminder {
    var title: String = ""
    var notes: String?
    var isCompleted: Bool = false
    var reminderDate: Date?
    var reminderTime: Date?
    
    var list: MyList?
    
    // Remember: an optional property is passed as parameter with a default value = nil and placed at the end of the prototype
    init(title: String, notes: String? = nil, reminderDate: Date? = nil, reminderTime: Date? = nil, list: MyList? = nil) {
        self.title = title
        self.notes = notes
        self.reminderDate = reminderDate
        self.reminderTime = reminderTime
        self.list = list
    }
    
}
