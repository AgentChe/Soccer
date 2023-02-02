//
//  SkillLevel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

enum SkillLevel: Codable, Hashable {
    case beginner, intermediate, advanced
}

// MARK: Public
extension SkillLevel {
    init?(code: Int) {
        switch code {
        case 0:
            self = .beginner
        case 1:
            self = .intermediate
        case 2:
            self = .advanced
        default:
            return nil
        }
    }
    
    var code: Int {
        switch self {
        case .beginner:
            return 0
        case .intermediate:
            return 1
        case .advanced:
            return 2
        }
    }
}
