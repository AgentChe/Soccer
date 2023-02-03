//
//  ProfileManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import RxSwift

protocol ProfileManagerProtocol {
    func set(skillLevel: SkillLevel?,
             weekSchedule: WeekSchedule?,
             drillsIds: [Int]?,
             focusZones: [FocusZone]?) -> Single<Void>
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?>
    func syncTokens(oldToken: String, newToken: String) -> Single<Void>
    func login(userToken: String) -> Single<Void>
}

final class ProfileManager {
    enum Constants {
        static let skillLevel = "profile_manager_skill_level_key"
        static let weekSchedule = "profile_manager_week_schedule_key"
        static let drillsIds = "profile_manager_drills_ids_key"
        static let focusZones = "profile_manager_focus_zones_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
    func set(skillLevel: SkillLevel? = nil,
             weekSchedule: WeekSchedule? = nil,
             drillsIds: [Int]? = nil,
             focusZones: [FocusZone]? = nil) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let weekScheduleDict = weekSchedule.map { weekSchedule -> [String: Bool] in
            [
                "su": weekSchedule.su,
                "mo": weekSchedule.mo,
                "tu": weekSchedule.tu,
                "we": weekSchedule.we,
                "th": weekSchedule.th,
                "fr": weekSchedule.fr,
                "sa": weekSchedule.sa
            ]
        }
        
        let request = SetRequest(userToken: userToken,
                                 skillLevel: skillLevel?.code,
                                 weekSchedule: weekScheduleDict,
                                 drills: drillsIds,
                                 focusZones: focusZones?.map { $0.code })
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                self?.store(skillLevel: skillLevel)
                self?.store(weekSchedule: weekSchedule)
                self?.store(drillsIds: drillsIds)
                self?.store(focusZones: focusZones)
            })
    }
    
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?> {
        forceUpdate ? loadProfile() : cachedProfile()
    }
    
    func syncTokens(oldToken: String, newToken: String) -> Single<Void> {
        let request = SyncTokensRequest(oldToken: oldToken,
                                        newToken: newToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func login(userToken: String) -> Single<Void> {
        let request = LoginRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
}

// MARK: Private
private extension ProfileManager {
    func loadProfile() -> Single<Profile?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetProfileRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetProfileResponse.map(from: $0) }
            .do(onSuccess: { [weak self] profile in
                self?.store(skillLevel: profile?.skillLevel)
                self?.store(weekSchedule: profile?.weekSchedule)
                self?.store(drillsIds: profile?.drillsIds)
                self?.store(focusZones: profile?.focusZones)
            })
    }
    
    func cachedProfile() -> Single<Profile?> {
        Single
            .zip(
                cachedSkillLevel(),
                cachedWeekSchedule(),
                cachedDrillsIds(),
                cachedFocusZones()
            )
            .map { skillLevel, weekSchedule, drillsIds, focusZones -> Profile in
                Profile(skillLevel: skillLevel,
                        weekSchedule: weekSchedule,
                        drillsIds: drillsIds,
                        focusZones: focusZones)
            }
    }
    
    func store(skillLevel: SkillLevel?) {
        guard let skillLevel = skillLevel else {
            return
        }
        
        let data = try? JSONEncoder().encode(skillLevel)
        
        UserDefaults.standard.set(data, forKey: Constants.skillLevel)
        
        ProfileMediator.shared.notify(skillLevel: skillLevel)
    }
    
    func cachedSkillLevel() -> Single<SkillLevel?> {
        Single<SkillLevel?>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.skillLevel) else {
                event(.success(nil))
                return Disposables.create()
            }
            
            let skillLevel = try? JSONDecoder().decode(SkillLevel.self, from: data)
            
            event(.success(skillLevel))
            
            return Disposables.create()
        }
    }
    
    func store(weekSchedule: WeekSchedule?) {
        guard let weekSchedule = weekSchedule else {
            return
        }
        
        let data = try? JSONEncoder().encode(weekSchedule)
        
        UserDefaults.standard.set(data, forKey: Constants.weekSchedule)
        
        ProfileMediator.shared.notify(weekSchedule: weekSchedule)
    }
    
    func cachedWeekSchedule() -> Single<WeekSchedule?> {
        Single<WeekSchedule?>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.weekSchedule) else {
                event(.success(nil))
                return Disposables.create()
            }
            
            let weekSchedule = try? JSONDecoder().decode(WeekSchedule.self, from: data)
            
            event(.success(weekSchedule))
            
            return Disposables.create()
        }
    }
    
    func store(drillsIds: [Int]?) {
        guard let drillsIds = drillsIds else {
            return
        }
        
        let data = try? JSONEncoder().encode(drillsIds)
        
        UserDefaults.standard.set(data, forKey: Constants.drillsIds)
        
        ProfileMediator.shared.notify(drillsIds: drillsIds)
    }
    
    func cachedDrillsIds() -> Single<[Int]?> {
        Single<[Int]?>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.drillsIds) else {
                event(.success(nil))
                return Disposables.create()
            }
            
            let drillsIds = try? JSONDecoder().decode([Int].self, from: data)
            
            event(.success(drillsIds))
            
            return Disposables.create()
        }
    }
    
    func store(focusZones: [FocusZone]?) {
        guard let focusZones = focusZones else {
            return
        }
        
        let data = try? JSONEncoder().encode(focusZones)
        
        UserDefaults.standard.set(data, forKey: Constants.focusZones)
        
        ProfileMediator.shared.notify(focusZones: focusZones)
    }
    
    func cachedFocusZones() -> Single<[FocusZone]?> {
        Single<[FocusZone]?>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.focusZones) else {
                event(.success(nil))
                return Disposables.create()
            }
            
            let focusZones = try? JSONDecoder().decode([FocusZone].self, from: data)
            
            event(.success(focusZones))
            
            return Disposables.create()
        }
    }
}
