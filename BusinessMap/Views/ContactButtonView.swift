//
//  ContactButtonView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 15/08/25.
//

import SwiftUI

struct ContactButtonView: View {
    var text: String
    var systemImage: String
    var disabled: Bool = false
    var action: () -> Void
    
    var body: some View {
        if disabled {
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                    
                    Label(text, systemImage: systemImage)
                        .labelStyle(.vertical)
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
            }
            .disabled(true)
            .foregroundStyle(.blue)
            .opacity(0.3)
        } else {
            Button {
                action()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                    
                    Label(text, systemImage: systemImage)
                        .labelStyle(.vertical)
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    ContactButtonView(text: "Call", systemImage: "phone.fill") {
        print("Test")
    }
}

#Preview("Disabled") {
    ContactButtonView(text: "Call", systemImage: "phone.fill", disabled: true) { print("Test")
    }
}
