//
//  DrillTrainingPrepareTimer.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Foundation

final class DrillTrainingPrepareTimer {
    enum Action {
        case tick(Int)
        case finish
    }
    
    private enum Constants {
        static let time = 5
    }
    
    private var timer: Timer?
    
    private var secondsLeft = Constants.time
}

// MARK: Public
extension DrillTrainingPrepareTimer {
    func start(action: @escaping ((Action) -> Void)) {
        stop()
        
        action(.tick(secondsLeft))
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            self.secondsLeft -= 1
            
            if self.secondsLeft == 0 {
                action(.finish)
                
                self.stop()
                
                return
            }
            
            action(.tick(self.secondsLeft))
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        
        secondsLeft = Constants.time
    }
}
