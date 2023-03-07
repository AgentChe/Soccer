//
//  HomeTableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

enum HomeTableElement {
    case offset(CGFloat)
    case title(String)
    case dailyPicks([DailyPicksElement])
    case drillCategories([DrillCategory])
    case tryDrillsTitle(String)
    case drillTraining(HomeDrillTrainingElement)
    case workoutsTitle(String)
    case workouts([WorkoutCover])
}

struct DailyPicksElement {
    enum DailyPicks {
        case drill(Drill)
        case workout(WorkoutCover)
    }
    
    let dailyPicks: DailyPicks
    let image: URL
    let type: String
    let name: String
    let tag1: String
    let tag2: String?
    let action: String
    
    init(drill: Drill, drillCategory: DrillCategory) {
        dailyPicks = .drill(drill)
        image = drill.image
        type = "Home.Drill".localized
        name = drill.name
        tag1 = "TODO" // drillTraining.skillLevel.localizedTitle // TODO
        tag2 = drillCategory.name
        action = "Home.StartTraining".localized
    }
    
    init(workout: WorkoutCover) {
        dailyPicks = .workout(workout)
        image = workout.image
        type = "Home.Training".localized
        name = workout.name
        tag1 = "TODO" // workout.skillLevel.localizedTitle // TODO
        tag2 = nil
        action = "Home.StartWorkout".localized
    }
}

struct HomeDrillTrainingElement {
    let drill: Drill
    let drillCategory: DrillCategory
}
