//
//  TrainViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.03.2023.
//

import RxSwift
import RxCocoa

final class TrainViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didSelectFilter = PublishRelay<TrainFilterView.Filter>()
    
    lazy var sections = makeSections()
    lazy var activity = RxActivityIndicator()
    
    private lazy var drillsSections = makeDrillsSections()
    private lazy var drills = makeDrills()
    private lazy var drillCategories = makeDrillCategories()
    private lazy var skillLevel = makeSkillLevel()
    
    private lazy var drillManager = DrillManager()
    private lazy var workoutManager = WorkoutManager()
    private lazy var profileManger = ProfileManager()
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension TrainViewModel {
    func makeSections() -> Driver<[TrainTableSection]> {
        Driver
            .combineLatest(didSelectFilter.asDriver(onErrorDriveWith: .never()), drillsSections)
            .map { filter, drillsSections -> [TrainTableSection] in
                switch filter {
                case .drills:
                    return drillsSections
                case .workouts:
                    return []
                }
            }
    }
    
    func makeDrillsSections() -> Driver<[TrainTableSection]> {
        Driver
            .combineLatest(drills, drillCategories, skillLevel)
            .map { drills, drillCategories, skillLevel -> [TrainTableSection] in
                let grouping = Dictionary(grouping: drills) { drill -> Int in
                    drill.categoryId
                }
                return grouping.compactMap { drillCategoryId, drills -> TrainTableSection? in
                    guard let drillCategory = drillCategories.first(where: { $0.id == drillCategoryId }) else {
                        return nil
                    }
                    
                    let elements: [TrainTableElement] = [
                        .title(.drillCategory(drillCategory)),
                        .trainings(Array(drills.prefix(3)).map { drill -> TrainTrainigElement in
                            TrainTrainigElement(
                                training: .drill(drill),
                                image: drill.image,
                                name: drill.name,
                                tag1: skillLevel.name,
                                tag2: drillCategories.first(where: { $0.id == drill.categoryId })?.name
                            )
                        })
                    ]
                    
                    return TrainTableSection(
                        elements: elements
                    )
                }
            }
    }
    
    func makeDrills() -> Driver<[Drill]> {
        skillLevel
            .flatMapLatest { [weak self] skillLevel -> Driver<[Drill]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Drill]> {
                    self.drillManager
                        .obtainDrills(categoryId: nil, levelId: skillLevel.id)
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
                    .trackActivity(self.activity)
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeDrillCategories() -> Driver<[DrillCategory]> {
        drillManager
            .obtainDrillCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSkillLevel() -> Driver<SkillLevel> {
        let skillLevelId = Driver
            .merge(
                profileManger
                    .obtainProfile(forceUpdate: false)
                    .compactMap { $0?.skillLevelId }
                    .asDriver(onErrorDriveWith: .never()),
                ProfileMediator.shared.skillLevelIdChange
                    .asDriver(onErrorDriveWith: .never())
            )
        
        return skillLevelId.flatMapLatest { [weak self] skillLevelId -> Driver<SkillLevel> in
            guard let self = self else {
                return .never()
            }
            
            return self.contentManager
                .obtainLevels(forceUpdate: false)
                .compactMap { skillLevels -> SkillLevel? in
                    skillLevels.first(where: { $0.id == skillLevelId })
                }
                .asDriver(onErrorDriveWith: .never())
        }
    }
}
