//
//  DrillTrainingJSONMapper.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

final class DrillTrainingJSONMapper {
    static func map(from json: [String: Any]) -> DrillTraining? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let skillLevelCode = json["skill_level"] as? Int,
            let skillLevel = SkillLevel(code: skillLevelCode),
            let imagePath = json["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let drillId = json["drill_id"] as? Int,
            let paid = json["paid"] as? Bool,
            let description = json["description"] as? String,
            let instruction = json["instruction"] as? String
        else {
            return nil
        }
        
        return DrillTraining(id: id,
                             name: name,
                             skillLevel: skillLevel,
                             image: imageUrl,
                             drillId: drillId,
                             paid: paid,
                             description: description,
                             instruction: instruction)
    }
}
