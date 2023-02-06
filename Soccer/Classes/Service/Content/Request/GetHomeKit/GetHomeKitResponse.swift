//
//  GetHomeKitResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

final class GetHomeKitResponse {
    static func map(from response: Any) -> HomeKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let dailyJSON = data["daily"] as? [String: Any],
            let dailyDrillJSON = dailyJSON["drill"] as? [String: Any],
            let dailyDrill = DrillTrainingCoverJSONMapper.map(from: dailyDrillJSON),
            let dailyWorkoutJSON = dailyJSON["workout"] as? [String: Any],
            let dailyWorkout = WorkoutTrainingCoverJSONMapper.map(from: dailyWorkoutJSON)
        else {
            return nil
        }
        
        let tryDrillsArray = data["try_drills"] as? [[String: Any]] ?? []
        let tryDrills = tryDrillsArray.compactMap { DrillTrainingCoverJSONMapper.map(from: $0) }
        
        let workoutsArray = data["workouts"] as? [[String: Any]] ?? []
        let workouts = workoutsArray.compactMap { WorkoutTrainingCoverJSONMapper.map(from: $0) }
        
        return HomeKit(dailyDrill: dailyDrill,
                       dailyWorkout: dailyWorkout,
                       tryDrills: tryDrills,
                       workouts: workouts)
    }
}
