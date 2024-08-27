//
//  View+Extensions.swift
//  RemindersClone
//
//  Created by Vahan on 27/08/2024.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
