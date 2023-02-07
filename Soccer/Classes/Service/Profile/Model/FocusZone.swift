//
//  FocusZone.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

enum FocusZone: Codable, Hashable {
    case arms, chest, core, glutes, legs
}

// MARK: Public
extension FocusZone {
    init?(code: Int) {
        switch code {
        case 0:
            self = .arms
        case 1:
            self = .chest
        case 2:
            self = .core
        case 3:
            self = .glutes
        case 4:
            self = .legs
        default:
            return nil
        }
    }
    
    var code: Int {
        switch self {
        case .arms:
            return 0
        case .chest:
            return 1
        case .core:
            return 2
        case .glutes:
            return 3
        case .legs:
            return 4
        }
    }
    
    var localizedTitle: String {
        switch self {
        case .arms:
            return "FocusZone.Arms".localized
        case .chest:
            return "FocusZone.Chest".localized
        case .core:
            return "FocusZone.Core".localized
        case .glutes:
            return "FocusZone.Glutes".localized
        case .legs:
            return "FocusZone.Legs".localized
        }
    }
}
