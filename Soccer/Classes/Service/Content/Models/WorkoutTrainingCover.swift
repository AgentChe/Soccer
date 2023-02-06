//
//  WorkoutTrainingCover.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

struct WorkoutTrainingCover: Codable, Hashable {
    let id: Int
    let name: String
    let skillLevel: SkillLevel
    let image: URL
    let focusZones: [FocusZone]
    let paid: Bool
}
