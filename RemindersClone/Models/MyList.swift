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
    // For iCloud implementation, we have to provide default value for all properties
    var name: String = ""
    var colorCode: String = "#34C759"
    var symbol: String = "list.bullet"
    
    @Relationship(deleteRule: .cascade) // this macro is for the database. It adds the foreign key / "deleteRule: .cascade": If I delete myList, all the reminders associated with this list will also be removed
    var reminders: [Reminder]?
    
    init(name: String, colorCode: String, symbol: String = "list.bullet") {
        self.name = name
        self.colorCode = colorCode
        self.symbol = symbol
    }
}
