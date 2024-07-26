//
//  List.swift
//  RemindersClone
//
//  Created by Vahan on 23/07/2024.
//

import Foundation
import SwiftData

@Model
class MyList {
    var name: String
    var colorCode: String
    
    
    @Relationship(deleteRule: .cascade) // this macro is for the database. It adds the foreign key / "deleteRule: .cascade": If I delete myList, all the reminders associated with this list will also be removed
    var reminders: [Reminder] = []
    
    init(name: String, colorCode: String) {
        self.name = name
        self.colorCode = colorCode
    }
}
