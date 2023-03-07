//
//  DrillTraining.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

struct DrillTraining: Codable, Hashable {
    let id: Int
    let name: String
    let skillLevelId: Int
    let image: URL
    let drillId: Int
    let paid: Bool
    let explanation: String
    let instruction: String
}
