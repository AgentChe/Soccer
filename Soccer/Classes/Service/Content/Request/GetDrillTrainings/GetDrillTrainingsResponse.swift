//
//  GetDrillTrainingsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

final class GetDrillTrainingsResponse {
    static func map(from response: Any) -> [DrillTraining] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
        
        return data.compactMap { drillTrainingJSON -> DrillTraining? in
            DrillTrainingJSONMapper.map(from: drillTrainingJSON)
        }
    }
}
