//
//  WorkoutTrainingCoverJSONMapper.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

final class WorkoutTrainingCoverJSONMapper {
    static func map(from json: [String: Any]) -> WorkoutTrainingCover? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let skillLevelId = json["level_id"] as? Int, // TODO
            let imagePath = json["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let paid = json["paid"] as? Bool
        else {
            return nil
        }
        
        return WorkoutTrainingCover(id: id,
                                  name: name,
                                  skillLevelId: skillLevelId,
                                  image: imageUrl,
                                  focusZones: [], // TODO
                                  paid: paid)
    }
}
