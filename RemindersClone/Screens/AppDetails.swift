//
//  AppDetails.swift
//  RemindersClone
//
//  Created by Vahan on 25/07/2024.
//

import SwiftUI

struct AppDetails: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "apple.logo")
                .font(.largeTitle)
            Text("Develop by Vahan Ducher")
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                }
            }
        }
    }
}

#Preview {
    AppDetails()
}
