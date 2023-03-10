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
    case stats(HomeStatsElement)
    case dailyPicks([DailyPicksElement])
    case drillCategories([DrillCategory])
    case tryDrillsTitle(String)
    case drill(HomeDrillElement)
    case workoutsTitle(String)
    case workouts([HomeWorkoutElement])
}

struct HomeStatsElement {
    let score: Int
    let skillLevel: SkillLevel
}

struct DailyPicksElement {
    enum DailyPicks {
        case drill(Drill)
        case workout(WorkoutTemplate)
    }
    
    let dailyPicks: DailyPicks
    let image: URL
    let type: String
    let name: String
    let tag1: String
    let tag2: String?
    let action: String
    
    init(drill: Drill, skillLevel: SkillLevel, drillCategory: DrillCategory) {
        dailyPicks = .drill(drill)
        image = drill.image
        type = "Home.Drill".localized
        name = drill.name
        tag1 = skillLevel.name
        tag2 = drillCategory.name
        action = "Home.StartTraining".localized
    }
    
    init(workout: WorkoutTemplate, skillLevel: SkillLevel) {
        dailyPicks = .workout(workout)
        image = workout.image
        type = "Home.Training".localized
        name = workout.name
        tag1 = skillLevel.name
        tag2 = nil
        action = "Home.StartWorkout".localized
    }
}

struct HomeDrillElement {
    let drill: Drill
    let drillCategory: DrillCategory
    let skillLevel: SkillLevel
}

struct HomeWorkoutElement {
    let workout: WorkoutCover
    let skillLevel: SkillLevel
}
