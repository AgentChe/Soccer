//
//  DrillTrainingCoverJSONMapper.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

final class DrillTrainingCoverJSONMapper {
    static func map(from json: [String: Any]) -> DrillTrainingCover? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let skillLevelCode = json["skill_level"] as? Int,
            let skillLevel = SkillLevel(code: skillLevelCode),
            let imagePath = json["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let drillId = json["drill_id"] as? Int,
            let paid = json["paid"] as? Bool
        else {
            return nil
        }
        
        return DrillTrainingCover(id: id,
                                  name: name,
                                  skillLevel: skillLevel,
                                  image: imageUrl,
                                  drillId: drillId,
                                  paid: paid)
    }
}
