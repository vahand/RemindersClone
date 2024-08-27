//
//  RemindersCloneApp.swift
//  RemindersClone
//
//  Created by Vahan on 22/07/2024.
//

import SwiftUI
import UserNotifications

@main
struct RemindersCloneApp: App {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MyListsScreen()
            }.modelContainer(for: MyList.self)
        }
    }
}
