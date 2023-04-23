//
//  CalendarViewModel.swift
//  Soccer
//
//  Created by Виталий Загороднов on 21.04.2023.
//

import RxSwift
import RxCocoa

final class CalendarViewModel {
    
    enum SchedulerType {
        case drill(customerDrillId: Int)
        case workout(customerDrillId: Int)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var activity = RxActivityIndicator()
    lazy var plan = makePlan()
    
    private let schedulerType: SchedulerType
    
    init(schedulerType: SchedulerType) {
        self.schedulerType = schedulerType
    }
    
    private lazy var planManager = PlanManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private let needRetryObtainPlan = PublishRelay<Void>()
}

// MARK: Private
private extension CalendarViewModel {
    func makePlan() -> Driver<Set<PlanOnDay>> {
        
        needRetryObtainPlan
            .startWith(())
            .flatMapLatest { [weak self] _ -> Observable<Set<PlanOnDay>> in
                guard let self else { return .never() }
                
                func source() -> Single<[PlanOnDay]> {
                    self.planManager.obtainPlan()
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                let calendar = Calendar.current
                
                
                let test: [PlanOnDay] = [
                    .init(day: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date(), status: .completed, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date(), status: .planned, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: -4, to: Date()) ?? Date(), status: .planned, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date(), status: .skipped, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: -6, to: Date()) ?? Date(), status: .completed, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: -5, to: Date()) ?? Date(), status: .completed, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date(), status: .completed, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: 0, to: Date()) ?? Date(), status: .planned, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: 3, to: Date()) ?? Date(), status: .skipped, drills: [], workouts: []),
                    .init(day: calendar.date(byAdding: .day, value: 5, to: Date()) ?? Date(), status: .planned, drills: [], workouts: []),
                ]
                return self.observableRetrySingle
                    .retry(source: source, trigger: trigger)
                    .map { _ in test }
                    .map { Set($0) }
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorJustReturn: [])
    }
}
