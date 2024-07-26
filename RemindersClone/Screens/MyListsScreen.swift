//
//  MyListsScreen.swift
//  RemindersClone
//
//  Created by Vahan on 22/07/2024.
//

import SwiftUI
import SwiftData

struct MyListsScreen: View {
    @Query private var lists: [MyList]
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isPresented: Bool = false
    @State private var showAppDetails: Bool = false
    
    var titleColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        List {
            Section {
                ForEach(lists, id: \.self) { list in
                    NavigationLink {
                        MyListDetailsScreen(myList: list)
                    } label: {
                        HStack {
                            ListIconView(color: Color(hex: list.colorCode), size: 32, iconName: "list.bullet")
                            Text(list.name)
                        }
                        .padding(2.5)
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
        .sheet(isPresented: $isPresented, content: {
            NavigationStack {
                AddMyListScreen()
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
                    isPresented = true
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
