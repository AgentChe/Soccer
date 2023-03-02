//
//  HomeKit.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

struct HomeKit: Codable, Hashable {
    let dailyDrill: DrillTraining
    let dailyWorkout: WorkoutCover
    let tryDrills: [DrillTraining]
    let workouts: [WorkoutCover]
}
