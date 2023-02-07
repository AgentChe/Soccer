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
    private lazy var drills = makeDrills()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension HomeViewModel {
    func makeElements() -> Driver<[HomeTableElement]> {
        Driver
            .combineLatest(homeKit, drills)
            .map { homeKit, drills -> [HomeTableElement] in
                guard let homeKit = homeKit else {
                    return []
                }
                
                var result = [HomeTableElement]()
                
                var dailyPicks = [DailyPicksElement]()
                if let drill = drills.first(where: { $0.id == homeKit.dailyDrill.drillId }) {
                    dailyPicks.append(.init(drillTrainingCover: homeKit.dailyDrill, drill: drill))
                }
                dailyPicks.append(.init(workout: homeKit.dailyWorkout))
                result.append(contentsOf: [
                    .title("Home.DailyPicks".localized),
                    .offset(16.scale),
                    .dailyPicks(dailyPicks)
                ])
                
                result.append(contentsOf: [
                    .offset(40.scale),
                    .drills(drills)
                ])
                
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
    
    func makeDrills() -> Driver<[Drill]> {
        contentManager
            .obtainDrills(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
