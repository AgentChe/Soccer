//
//  GlossaryManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.03.2023.
//

import RxSwift

protocol GlossaryManagerProtocol {
    func obtainLevels(forceUpdate: Bool) -> Single<[SkillLevel]>
    func obtainFocusZones(forceUpdate: Bool) -> Single<[FocusZone]>
    func obtainWorkoutSteps(forceUpdate: Bool) -> Single<[WorkoutStep]>
}

final class GlossaryManager {
    enum Constants {
        static let skillLevels = "glossary_manager_skill_levels_key"
        static let focusZones = "glossary_manager_focus_zones_key"
        static let workoutSteps = "glossary_manager_workout_steps_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: GlossaryManagerProtocol
extension GlossaryManager: GlossaryManagerProtocol {
    func obtainLevels(forceUpdate: Bool) -> Single<[SkillLevel]> {
        forceUpdate ? loadLevels() : cachedLevels()
    }
    
    func obtainFocusZones(forceUpdate: Bool) -> Single<[FocusZone]> {
        forceUpdate ? loadFocusZones() : cachedFocusZones()
    }
    
    func obtainWorkoutSteps(forceUpdate: Bool) -> Single<[WorkoutStep]> {
        forceUpdate ? loadWorkoutSteps() : cachedWorkoutSteps()
    }
}

// MARK: Private
private extension GlossaryManager {
    func loadLevels() -> Single<[SkillLevel]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSkillLevelsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetSkillLevelsResponse.map(from: $0) }
            .do(onSuccess: { levels in
                guard let data = try? JSONEncoder().encode(levels) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.skillLevels)
            })
    }
    
    func cachedLevels() -> Single<[SkillLevel]> {
        Single<[SkillLevel]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.skillLevels) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let levels = try? JSONDecoder().decode([SkillLevel].self, from: data)
            
            event(.success(levels ?? []))
            
            return Disposables.create()
        }
    }
    
    func loadFocusZones() -> Single<[FocusZone]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetFocusZonesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetFocusZonesResponse.map(from: $0) }
            .do(onSuccess: { focusZones in
                guard let data = try? JSONEncoder().encode(focusZones) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.focusZones)
            })
    }
    
    func cachedFocusZones() -> Single<[FocusZone]> {
        Single<[FocusZone]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.focusZones) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let focusZones = try? JSONDecoder().decode([FocusZone].self, from: data)
            
            event(.success(focusZones ?? []))
            
            return Disposables.create()
        }
    }
    
    func loadWorkoutSteps() -> Single<[WorkoutStep]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetWorkoutStepsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetWorkoutStepsResponse.map(from: $0) }
            .do(onSuccess: { workoutSteps in
                guard let data = try? JSONEncoder().encode(workoutSteps) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.workoutSteps)
            })
    }
    
    func cachedWorkoutSteps() -> Single<[WorkoutStep]> {
        Single<[WorkoutStep]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.workoutSteps) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let workoutSteps = try? JSONDecoder().decode([WorkoutStep].self, from: data)
            
            event(.success(workoutSteps ?? []))
            
            return Disposables.create()
        }
    }
}
