//
//  LabelStyleConfig.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 15/08/25.
//

import SwiftUI

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 7) {
            configuration.icon
            configuration.title
        }
    }
}

extension LabelStyle where Self == VerticalLabelStyle {
    static var vertical: VerticalLabelStyle {
        VerticalLabelStyle()
    }
}

#Preview {
    Label("Call", systemImage: "phone.fill")
        .labelStyle(.vertical)
}
