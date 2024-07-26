//
//  RemindersCloneApp.swift
//  RemindersClone
//
//  Created by Vahan on 22/07/2024.
//

import SwiftUI

@main
struct RemindersCloneApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MyListsScreen()
            }.modelContainer(for: MyList.self)
        }
    }
}
