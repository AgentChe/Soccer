//
//  HomeViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var homeKit = makeHomeKit()
    private lazy var skillLevels = makeSkillLevels()
    private lazy var drillCategories = makeDrillCategories()
    private lazy var workoutCovers = makeWorkoutCovers()
    
    private lazy var contentManager = ContentManager()
    private lazy var drillManager = DrillManager()
    private lazy var workoutManager = WorkoutManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension HomeViewModel {
    func makeElements() -> Driver<[HomeTableElement]> {
        Driver
            .combineLatest(homeKit, skillLevels, drillCategories, workoutCovers)
            .map { [weak self] homeKit, skillLevels, drillCategories, workoutCovers -> [HomeTableElement] in
                guard let self = self, let homeKit = homeKit else {
                    return []
                }
                
                var result = [HomeTableElement]()
                
                let stats = self.statsElements(homeKit: homeKit, skillLevels: skillLevels)
                result.append(contentsOf: stats)
                
                let dailyPicks = self.dailyPicksElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels,
                    drillCategories: drillCategories
                )
                result.append(contentsOf: dailyPicks)
                
                let drillCategoriesElements: [HomeTableElement] = [
                    .offset(40.scale),
                    .drillCategories(drillCategories)
                ]
                result.append(contentsOf: drillCategoriesElements)
                
                let drills = self.drillsElements(
                    homeKit: homeKit,
                    skillLevels: skillLevels,
                    drillCategories: drillCategories
                )
                result.append(contentsOf: drills)
                
                let workouts = self.workoutsElements(
                    homeKit: homeKit,
                    workoutCovers: workoutCovers,
                    skillLevels: skillLevels
                )
                result.append(contentsOf: workouts)
                
                return result
            }
    }
    
    func makeHomeKit() -> Driver<HomeKit?> {
        func source() -> Single<HomeKit?> {
            contentManager
                .obtainHomeKit()
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return self.observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeSkillLevels() -> Driver<[SkillLevel]> {
        contentManager
            .obtainLevels(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeDrillCategories() -> Driver<[DrillCategory]> {
        drillManager
            .obtainDrillCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeWorkoutCovers() -> Driver<[WorkoutCover]> {
        workoutManager
            .obtainWorkoutCovers(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Private (Additional)
private extension HomeViewModel {
    func statsElements(homeKit: HomeKit, skillLevels: [SkillLevel]) -> [HomeTableElement] {
        guard let skillLevel = skillLevels.first(where: { $0.id == homeKit.levelId }) else {
            return []
        }
        
        let element = HomeStatsElement(
            score: homeKit.score,
            skillLevel: skillLevel
        )
        
        return [.stats(element)]
    }
    
    func dailyPicksElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel],
        drillCategories: [DrillCategory]
    ) -> [HomeTableElement] {
        let drills = homeKit.dailyDrills.compactMap { drill -> DailyPicksElement? in
            guard
                let skillLevel = skillLevels.first(where: { $0.id == drill.skillLevelId }),
                let drillCategory = drillCategories.first(where: { $0.id == drill.categoryId })
            else {
                return nil
            }
            
            return DailyPicksElement(
                drill: drill,
                skillLevel: skillLevel,
                drillCategory: drillCategory
            )
        }
        
        let workouts = homeKit.dailyWorkouts.compactMap { workout -> DailyPicksElement? in
            guard let skillLevel = skillLevels.first(where: { $0.id == workout.id }) else {
                return nil
            }
            
            return DailyPicksElement(
                workout: workout,
                skillLevel: skillLevel
            )
        }
        
        let elements = drills + workouts
        
        if elements.isEmpty {
            return []
        }
        
        return [
            .offset(32.scale),
            .title("Home.DailyPicks".localized),
            .offset(16.scale),
            .dailyPicks(elements)
        ]
    }
    
    func drillsElements(
        homeKit: HomeKit,
        skillLevels: [SkillLevel],
        drillCategories: [DrillCategory]
    ) -> [HomeTableElement] {
        guard !homeKit.tryDrills.isEmpty else {
            return []
        }
        
        var result: [HomeTableElement] = [
            .offset(43.scale),
            .tryDrillsTitle("Home.TryDrills".localized),
            .offset(19.scale)
        ]
        
        homeKit.tryDrills.enumerated().forEach { index, drill in
            guard
                let drillCategory = drillCategories.first(where: { $0.id == drill.categoryId }),
                let skillLevel = skillLevels.first(where: { $0.id == drill.skillLevelId })
            else {
                return
            }
            
            let element = HomeDrillElement(
                drill: drill,
                drillCategory: drillCategory,
                skillLevel: skillLevel
            )
            result.append(.drill(element))
            
            if (homeKit.tryDrills.count - 1) != index {
                result.append(.offset(16.scale))
            }
        }
        
        return result
    }
    
    func workoutsElements(
        homeKit: HomeKit,
        workoutCovers: [WorkoutCover],
        skillLevels: [SkillLevel]
    ) -> [HomeTableElement] {
        let workoutElements = workoutCovers.compactMap { workoutCover -> HomeWorkoutElement? in
            guard let skillLevel = skillLevels.first(where: { $0.id == homeKit.levelId }) else {
                return nil
            }
            
            return HomeWorkoutElement(
                workout: workoutCover,
                skillLevel: skillLevel
            )
        }.prefix(3)
        
        
        
        guard !workoutElements.isEmpty else {
            return []
        }
        
        return [
            .offset(43.scale),
            .workoutsTitle("Home.ImproveYourFitness".localized),
            .offset(19.scale),
            .workouts(Array(workoutElements))
        ]
    }
}
