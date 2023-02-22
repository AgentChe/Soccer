//
//  DrillTrainingLifeCyrcle.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

protocol DrillTrainingLifeCyrcleDelegate: AnyObject {
    func drillTrainingPrepare()
    func drillTrainingReadyIn(seconds: Int)
    func drillTrainingPrepared()
    func drillTrainingDidStart()
    func drillTrainingTick(seconds: Int)
    func drillTrainigPaused()
    func drillTrainingStopped()
}

final class DrillTrainingLifeCyrcle {
    weak var delegate: DrillTrainingLifeCyrcleDelegate?
    
    private lazy var timer = DrillTrainingPrepareTimer()
}

// MARK: Public
extension DrillTrainingLifeCyrcle {
    func startTraining() {
        
    }
    
    func refreshTraining() {
        
    }
    
    func pauseTraining() {
        
    }
    
    func continueTraining() {
        
    }
    
    func stopTraining() {
        
    }
}
