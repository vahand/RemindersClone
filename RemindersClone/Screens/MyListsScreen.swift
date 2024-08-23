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
    
    @State private var selectedList: MyList?
    
    @State private var actionSheet: MyListScreenSheets?
    
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
    
    var body: some View {
        List {
            Section {
                ForEach(lists, id: \.self) { list in
                    NavigationLink(value: list) {
                        MyListCellView(list: list)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedList = list
                            }
                            .onLongPressGesture(minimumDuration: 0.5) {
                                actionSheet = .editList(list)
                            }
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
