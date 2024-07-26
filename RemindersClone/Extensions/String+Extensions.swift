//
//  String+Extensions.swift
//  RemindersClone
//
//  Created by Vahan on 25/07/2024.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
