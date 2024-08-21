//
//  Date+Extensions.swift
//  RemindersClone
//
//  Created by Vahan on 21/08/2024.
//

import Foundation

extension Date {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        let calendar = Calendar.current
        return calendar.isDateInTomorrow(self)
    }
}
