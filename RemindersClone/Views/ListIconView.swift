//
//  ListIconView.swift
//  RemindersClone
//
//  Created by Vahan on 23/07/2024.
//

import SwiftUI

struct ListIconView: View {
    let color: Color
    let size: Int
    let iconName: String
    
    var body: some View {
        ZStack {
            if (size >= 50) {
                Circle()
                    .fill(color.gradient)
                    .frame(width: CGFloat(size), height: CGFloat(size))
                    .shadow(color: color,radius: 4)
            } else {
                Circle()
                    .fill(color)
                    .frame(width: CGFloat(size), height: CGFloat(size))
            }
            
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: CGFloat(size / 2), height: CGFloat(size / 2))
                .foregroundStyle(.white)
                .fontWeight(.bold)
        }
    }
}


#Preview {
    ListIconView(color: .red, size: 80, iconName: "list.bullet")
}
