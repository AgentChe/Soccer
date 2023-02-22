//
//  DrillTrainingsViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import RxSwift
import RxCocoa

final class DrillTrainingsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private let drill: Driver<Drill>
    private lazy var drillTrainings = makeDrillTrainings()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var contentManager = ContentManager()
    private lazy var sessionManager = SessionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(drill: Drill) {
        self.drill = BehaviorRelay(value: drill).asDriver()
    }
}

// MARK: Private
private extension DrillTrainingsViewModel {
    func makeElements() -> Driver<[DrillTrainingsTableElement]> {
        Driver
            .combineLatest(drill, drillTrainings, activeSubscription)
            .map { drill, drillTrainings, activeSubscription -> [DrillTrainingsTableElement] in
                drillTrainings.map { drillTraining -> DrillTrainingsTableElement in
                    DrillTrainingsTableElement(drillTraining: drillTraining,
                                               drill: drill,
                                               locked: drillTraining.paid ? !activeSubscription : false)
                }
            }
    }
    
    func makeDrillTrainings() -> Driver<[DrillTraining]> {
        drill
            .flatMapLatest { [weak self] drill -> Driver<[DrillTraining]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[DrillTraining]> {
                    self.contentManager
                        .obtainDrillTrainings(at: drill.id)
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
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { [weak self] in
                guard let self = self else {
                    return false
                }
                
                return self.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
