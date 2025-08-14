//
//  SheetViewModel.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 14/08/25.
//

import Foundation
import SwiftUI
import Combine


extension PresentationDetent {
    static var small: PresentationDetent {
        .fraction(0.15)
    }
    
    static var third: PresentationDetent {
        .fraction(0.33)
    }
}

#if DEBUG
extension SheetViewModel {
    static func preview(withDetent detent: SheetViewModel.SheetDetent) -> SheetViewModel {
        let vm = SheetViewModel()
        vm.detent = detent
        return vm
    }
}
#endif

class SheetViewModel: ObservableObject {
    
    enum SheetDetent: CaseIterable {
        case small, medium, large
        
        var presentationDetent: PresentationDetent {
            switch self {
            case .small:
                return .small
            case .medium:
                return .third
            case .large:
                return .large
            }
        }
        
        static func from(_ pd: PresentationDetent) -> Self {
            switch pd {
            case .small: return .small
            case .third: return .medium
            case .large: return .large
            default : return .medium
            }
        }
    }
    
    @Published var detent: SheetDetent = .medium
    @Published var isPresented: Bool = false
    
    func setDetent(_ detent: SheetDetent) {
        self.detent = detent
    }
    
    func toggleSheet() {
        isPresented.toggle()
    }
}
