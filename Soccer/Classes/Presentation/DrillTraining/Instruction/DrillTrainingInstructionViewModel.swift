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
    
    private let drill: Driver<Drill>
    private lazy var drillCategories = makeDrillCategories()
    
    private lazy var drillManager = DrillManager()
    
    init(drill: Drill) {
        self.drill = BehaviorRelay(value: drill).asDriver()
    }
}

// MARK: Private
private extension DrillTrainingInstructionViewModel {
    func makeElements() -> Driver<[DTITableElement]> {
        Driver
            .combineLatest(drill, drillCategories)
            .map { drill, drillCategories -> [DTITableElement] in
                var result = [DTITableElement]()
                
                let headerElement = DTIHeaderElement(image: drill.image,
                                                     name: drill.name,
                                                     skillLevel: "TODO", //drill.skillLevel.localizedTitle, // TODO
                                                     drillCategory: drillCategories.first(where: { $0.id == drill.categoryId })?.name ?? "")
                result.append(.header(headerElement))
                
                result.append(contentsOf: [
                    .offset(1.scale),
                    .description(drill.explanation)
                ])
                
                result.append(contentsOf: [
                    .offset(16.scale),
                    .buttons
                ])
                
                result.append(contentsOf: [
                    .offset(24.scale),
                    .instruction(drill.instruction)
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
