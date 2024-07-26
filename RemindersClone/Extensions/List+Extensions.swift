//
//  List+Extensions.swift
//  RemindersClone
//
//  Created by Vahan on 26/07/2024.
//

import Foundation
import SwiftUI

struct MyListViewModifier : ViewModifier {
    let isListPlain : Bool
    
    func body(content: Content) -> some View {
        if isListPlain {
            content.listStyle(.plain)
        } else {
            content.listStyle(.insetGrouped)
        }
    }
}

extension View {
    func myListStyle(isListPlain : Bool) -> some View {
        modifier(MyListViewModifier(isListPlain: isListPlain))
    }
}
