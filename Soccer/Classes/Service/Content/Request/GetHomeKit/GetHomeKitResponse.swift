//
//  GetHomeKitResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import Foundation

final class GetHomeKitResponse {
    static func map(from response: Any) -> HomeKit? {
        nil
//        guard
//            let json = response as? [String: Any],
//            let data = json["_data"] as? [String: Any],
//            let dailyJSON = data["daily"] as? [String: Any],
//            let dailyDrillJSON = dailyJSON["drill"] as? [String: Any],
//            let dailyDrill = DrillTrainingJSONMapper.map(from: dailyDrillJSON),
//            let dailyWorkoutJSON = dailyJSON["workout"] as? [String: Any],
//            let dailyWorkout = WorkoutCoverJSONMapper.map(from: dailyWorkoutJSON)
//        else {
//            return nil
//        }
//
//        let tryDrillsArray = data["try_drills"] as? [[String: Any]] ?? []
//        let tryDrills = tryDrillsArray.compactMap { DrillTrainingJSONMapper.map(from: $0) }
//
//        let workoutsArray = data["workouts"] as? [[String: Any]] ?? []
//        let workouts = workoutsArray.compactMap { WorkoutCoverJSONMapper.map(from: $0) }
//
//        return HomeKit(dailyDrill: dailyDrill,
//                       dailyWorkout: dailyWorkout,
//                       tryDrills: tryDrills,
//                       workouts: workouts)
    }
}
