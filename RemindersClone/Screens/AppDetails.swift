//
//  AppDetails.swift
//  RemindersClone
//
//  Created by Vahan on 25/07/2024.
//

import SwiftUI

struct AppDetails: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        VStack {
            Image(systemName: "apple.logo")
                .font(.largeTitle)
                .padding()
            Text("Developped by ") +
            Text("Vahan Ducher")
                .fontWeight(.heavy)
            
            VStack {
                Link(destination: URL(string: "https://x.com/VahanDucher")!, label: {
                    HStack {
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(colorScheme == .dark ? .white : .black, lineWidth: 4)
                            .frame(width: 130, height: 50)
                            .overlay {
                                Image((colorScheme == .dark) ? "X_logo_white" : "X_logo_black")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                    }
                })
                Link(destination: URL(string: "https://github.com/vahand")!, label: {
                    HStack {
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(colorScheme == .dark ? .white : .black, lineWidth: 4)
                            .frame(width: 130, height: 50)
                            .overlay {
                                Image((colorScheme == .dark) ? "Git_logo_white" : "Git_logo_black")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                    }
                })
            }
            .padding()
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
