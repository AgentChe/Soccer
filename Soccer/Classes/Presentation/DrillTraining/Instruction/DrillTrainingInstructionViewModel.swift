//
//  DrillTrainingInstructionViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import RxSwift
import RxCocoa

final class DrillTrainingInstructionViewModel {
    lazy var elements = makeElements()
    
    private let drillTraining: Driver<DrillTraining>
    private lazy var drillCategories = makeDrillCategories()
    
    private lazy var drillManager = DrillManager()
    
    init(drillTraining: DrillTraining) {
        self.drillTraining = BehaviorRelay(value: drillTraining).asDriver()
    }
}

// MARK: Private
private extension DrillTrainingInstructionViewModel {
    func makeElements() -> Driver<[DTITableElement]> {
        Driver
            .combineLatest(drillTraining, drillCategories)
            .map { drillTraining, drillCategories -> [DTITableElement] in
                var result = [DTITableElement]()
                
                let headerElement = DTIHeaderElement(image: drillTraining.image,
                                                     name: drillTraining.name,
                                                     skillLevel: "TODO", //drillTraining.skillLevel.localizedTitle, // TODO
                                                     drillCategory: drillCategories.first(where: { $0.id == drillTraining.drillId })?.name ?? "")
                result.append(.header(headerElement))
                
                result.append(contentsOf: [
                    .offset(1.scale),
                    .description(drillTraining.explanation)
                ])
                
                result.append(contentsOf: [
                    .offset(16.scale),
                    .buttons
                ])
                
                result.append(contentsOf: [
                    .offset(24.scale),
                    .instruction(drillTraining.instruction)
                ])
                
                return result
            }
    }
    
    func makeDrillCategories() -> Driver<[DrillCategory]> {
        drillManager
            .obtainDrillCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
}
