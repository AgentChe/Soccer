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
    private lazy var drillCategories = makeDrillCategories()
    
    private lazy var contentManager = ContentManager()
    private lazy var drillManager = DrillManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension HomeViewModel {
    func makeElements() -> Driver<[HomeTableElement]> {
        Driver
            .combineLatest(homeKit, drillCategories)
            .map { homeKit, drillCategories -> [HomeTableElement] in
                guard let homeKit = homeKit else {
                    return []
                }
                
                var result = [HomeTableElement]()
                
                var dailyPicks = [DailyPicksElement]()
                if let drillCategory = drillCategories.first(where: { $0.id == homeKit.dailyDrill.drillId }) {
                    dailyPicks.append(.init(drillTraining: homeKit.dailyDrill, drillCategory: drillCategory))
                }
                dailyPicks.append(.init(workout: homeKit.dailyWorkout))
                result.append(contentsOf: [
                    .title("Home.DailyPicks".localized),
                    .offset(16.scale),
                    .dailyPicks(dailyPicks)
                ])
                
                result.append(contentsOf: [
                    .offset(40.scale),
                    .drillCategories(drillCategories)
                ])
                
                if !homeKit.tryDrills.isEmpty {
                    result.append(contentsOf: [
                        .offset(43.scale),
                        .tryDrillsTitle("Home.TryDrills".localized),
                        .offset(19.scale)
                    ])
                    
                    homeKit.tryDrills.enumerated().forEach { index, drillTraining in
                        guard let drillCategory = drillCategories.first(where: { drillTraining.id == $0.id }) else {
                            return
                        }
                        
                        if index != 0 {
                            result.append(.offset(16.scale))
                        }
                        
                        let element = HomeDrillTrainingElement(drillTraining: drillTraining,
                                                               drillCategory: drillCategory)
                        result.append(.drillTraining(element))
                    }
                }
                
                if !homeKit.workouts.isEmpty {
                    result.append(contentsOf: [
                        .offset(43.scale),
                        .tryDrillsTitle("Home.ImproveYourFitness".localized),
                        .offset(19.scale),
                        .workouts(homeKit.workouts)
                    ])
                }
                
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
    
    func makeDrillCategories() -> Driver<[DrillCategory]> {
        drillManager
            .obtainDrillCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
