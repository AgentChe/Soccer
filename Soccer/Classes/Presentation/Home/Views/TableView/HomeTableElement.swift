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
    case drills([Drill])
    case tryDrillsTitle(String)
    case drillTraining(HomeDrillTrainingElement)
    case workoutsTitle(String)
    case workouts([WorkoutTrainingCover])
}

struct DailyPicksElement {
    enum DailyPicks {
        case drill(DrillTraining)
        case workout(WorkoutTrainingCover)
    }
    
    let dailyPicks: DailyPicks
    let image: URL
    let type: String
    let name: String
    let tag1: String
    let tag2: String?
    let action: String
    
    init(drillTraining: DrillTraining, drill: Drill) {
        dailyPicks = .drill(drillTraining)
        image = drillTraining.image
        type = "Home.Drill".localized
        name = drillTraining.name
        tag1 = "TODO" // drillTraining.skillLevel.localizedTitle // TODO
        tag2 = drill.name
        action = "Home.StartTraining".localized
    }
    
    init(workout: WorkoutTrainingCover) {
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
    let drillTraining: DrillTraining
    let drill: Drill
}
