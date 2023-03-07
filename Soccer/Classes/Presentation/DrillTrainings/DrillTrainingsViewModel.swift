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
    
    private let drillCategory: Driver<DrillCategory>
    private lazy var drills = makeDrills()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var drillManager = DrillManager()
    private lazy var sessionManager = SessionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(drillCategory: DrillCategory) {
        self.drillCategory = BehaviorRelay(value: drillCategory).asDriver()
    }
}

// MARK: Private
private extension DrillTrainingsViewModel {
    func makeElements() -> Driver<[DrillTrainingsTableElement]> {
        Driver
            .combineLatest(drillCategory, drills, activeSubscription)
            .map { drillCategory, drills, activeSubscription -> [DrillTrainingsTableElement] in
                drills.map { drill -> DrillTrainingsTableElement in
                    DrillTrainingsTableElement(drill: drill,
                                               drillCategory: drillCategory,
                                               locked: drill.paid ? !activeSubscription : false)
                }
            }
    }
    
    func makeDrills() -> Driver<[Drill]> {
        drillCategory
            .flatMapLatest { [weak self] drillCategory -> Driver<[Drill]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[Drill]> {
                    self.drillManager
                        .obtainDrills(categoryId: drillCategory.id, levelId: 1) // TODO
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
