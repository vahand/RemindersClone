//
//  MyListsScreen.swift
//  RemindersClone
//
//  Created by Vahan on 22/07/2024.
//

import SwiftUI
import SwiftData

enum ReminderStatsType: Int, Identifiable {
    case today
    case scheduled
    case all
    case completed
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .scheduled:
            return "Scheduled"
        case .all:
            return "All"
        case .completed:
            return "Completed"
        }
    }
}

struct MyListsScreen: View {
    @Query private var lists: [MyList]
    @Query private var reminders: [Reminder]
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    
    @State private var isPresented: Bool = false
    @State private var showAppDetails: Bool = false
    
    @State private var selectedList: MyList?
    
    @State private var actionSheet: MyListScreenSheets?
    
    @State private var reminderStatsType: ReminderStatsType?
    
    enum MyListScreenSheets: Identifiable {
        case newList
        case editList(MyList)
        
        var id: Int { // since the enum is Identifiable, we do return something
            switch self {
                case .newList:
                    return 1
                case .editList(let myList):
                    return myList.hashValue
            }
        }
    }
    
    var titleColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var inCompleteReminders: [Reminder] {
        reminders.filter {
            !$0.isCompleted
        }
    }
    
    private var todayReminders: [Reminder] {
        reminders.filter {
            guard let reminderDate = $0.reminderDate else { return false }
            
            return reminderDate.isToday && !$0.isCompleted
        }
    }
    
    private var completedReminders: [Reminder] {
        reminders.filter {
            $0.isCompleted
        }
    }
    
    private var scheduledReminders: [Reminder] {
        reminders.filter {
            $0.reminderDate != nil && !$0.isCompleted
        }
    }
    
    private func reminders(for type: ReminderStatsType) -> [Reminder] {
        switch type {
        case .all:
            return inCompleteReminders
        case .completed:
            return completedReminders
        case .scheduled:
            return scheduledReminders
        case .today:
            return todayReminders
        }
    }
    
    var body: some View {
        List {
            VStack {
                HStack {
                    CategorieRowView(title: "Today", remindersCount: todayReminders.count, iconName: "calendar", color: .blue)
                        .onTapGesture {
                            reminderStatsType = .today
                        }
                    CategorieRowView(title: "Scheduled", remindersCount: scheduledReminders.count, iconName: "calendar", color: .red)
                        .onTapGesture {
                            reminderStatsType = .scheduled
                        }
                }
                HStack {
                    CategorieRowView(title: "All", remindersCount: inCompleteReminders.count, iconName: "tray.circle.fill", color: .black)
                        .onTapGesture {
                            reminderStatsType = .all
                        }
                    CategorieRowView(title: "Completed", remindersCount: completedReminders.count, iconName: "checkmark.circle.fill", color: .gray)
                        .onTapGesture {
                            reminderStatsType = .completed
                        }
                }
            }
            Section {
                ForEach(lists, id: \.self) { list in
                    NavigationLink(value: list) {
                        MyListCellView(list: list)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedList = list
                            }
                            .contextMenu(menuItems: {
                                Button {
                                    actionSheet = .editList(list)
                                } label: {
                                    HStack {
                                        Text("Show List Info")
                                        Image(systemName: "info.circle")
                                    }
                                }
                                
                                Divider()
                                
                                Button(role: .destructive) {
                                    context.delete(list)
                                } label: {
                                    HStack {
                                        Text("Delete List")
                                        Image(systemName: "trash")
                                    }
                                }
                            })
                    }
                }
            } header: {
                Text("My Lists")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(titleColor)
                    .textCase(.none)
            }
        }
        .navigationDestination(item: $selectedList, destination: { list in
            MyListDetailsScreen(myList: list)
        })
        .navigationDestination(item: $reminderStatsType, destination: { type in
            NavigationStack {
                ReminderListView(reminders: reminders(for: type))
            }.navigationTitle(type.title)
        })
        .sheet(item: $actionSheet, content: { actionSheet in
            switch actionSheet {
            case .newList:
                NavigationStack {
                    AddMyListScreen()
                }
            case .editList(let myList):
                NavigationStack {
                    AddMyListScreen(myList: myList)
                }
            }
        })
        .sheet(isPresented: $showAppDetails, content: {
            NavigationStack {
                AppDetails()
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAppDetails = true
                } label: {
                    Image(systemName: "info.circle")
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
//                    isNewReminderPresented = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Reminder")
                    }
                    .fontWeight(.bold)
                }
                Button {
                    actionSheet = .newList
                } label: {
                    Text("Add List")
                }
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListsScreen()
    }.modelContainer(previewContainer)
}
