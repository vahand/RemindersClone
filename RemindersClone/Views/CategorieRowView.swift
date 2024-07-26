//
//  CategorieRowView.swift
//  RemindersClone
//
//  Created by Vahan on 25/07/2024.
//

import SwiftUI

struct CategorieRowView: View {
    let title: String
    let remindersCount: Int
    let iconName: String
    let color: Color
    let width: CGFloat

    init(title: String, remindersCount: Int, iconName: String, color: Color, width: CGFloat = 170) {
        self.title = title
        self.remindersCount = remindersCount
        self.iconName = iconName
        self.color = color
        self.width = width
    }
    
    var body: some View {
        Section {
            HStack {
                VStack(alignment: .leading) {
                    ListIconView(color: color, size: 32, iconName: iconName)
                    Text(title)
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                        .padding(.top, 2)
                }
                Spacer()
                Text("\(remindersCount)")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .font(.caption)
                    .padding(.trailing, 4)
                    .padding(.top, 3)
                    .frame(
                        maxHeight: .infinity,
                        alignment: .top
                    )
            }
            .padding(8)
            .frame(
                maxWidth: width,
                maxHeight: 75
            )
        }
    }
}

#Preview {
    CategorieRowView(title: "Scheduled", remindersCount: 3, iconName: "calendar", color: .red)
}
