//
//  MyListCellView.swift
//  RemindersClone
//
//  Created by Vahan on 23/08/2024.
//

import SwiftUI

struct MyListCellView: View {
    let list: MyList
    
    var body: some View {
        HStack {
            ListIconView(color: Color(hex: list.colorCode), size: 32, iconName: list.symbol)
            Text(list.name)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
        }
        .padding(2.5)
    }
}

//#Preview {
//    MyListCellView()
//}
