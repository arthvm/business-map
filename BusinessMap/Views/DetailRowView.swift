//
//  DetailRowView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 15/08/25.
//

import SwiftUI

struct DetailRowView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.vertical, 1)
            
            Spacer()
            
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    DetailRowView(title: "Test", value: "testvalue")
}
