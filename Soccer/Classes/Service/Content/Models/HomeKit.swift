//
//  HomeKit.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

struct HomeKit: Codable, Hashable {
    let dailyDrill: DrillTrainingCover
    let dailyWorkout: WorkoutTrainingCover
    let tryDrills: [DrillTrainingCover]
    let workouts: [WorkoutTrainingCover]
}
