//
//  WorkoutCover.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

struct WorkoutCover: Codable, Hashable {
    let id: Int
    let name: String
    let skillLevelId: Int // TODO
    let image: URL
    let focusZones: [FocusZone]
    let paid: Bool
}
