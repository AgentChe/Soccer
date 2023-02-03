//
//  ProfileMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

import RxSwift
import RxCocoa

protocol ProfileMediatorDelegate: AnyObject {
    func profileMediatorDidChange(skillLevel: SkillLevel)
    func profileMediatorDidChange(weekSchedule: WeekSchedule)
    func profileMediatorDidChange(drillsIds: [Int])
    func profileMediatorDidChange(focusZones: [FocusZone])
}

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private lazy var skillLevelChangeTrigger = PublishRelay<SkillLevel>()
    private lazy var weekScheduleChangeTrigger = PublishRelay<WeekSchedule>()
    private lazy var drillsIdsChangeTrigger = PublishRelay<[Int]>()
    private lazy var focusZonesChangeTrigger = PublishRelay<[FocusZone]>()
    
    private var delegates = [Weak<ProfileMediatorDelegate>]()
    
    private init() {}
}

// MARK: Public
extension ProfileMediator {
    func notify(skillLevel: SkillLevel) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach { $0.weak?.profileMediatorDidChange(skillLevel: skillLevel) }
            
            self?.skillLevelChangeTrigger.accept(skillLevel)
        }
    }
    
    func notify(weekSchedule: WeekSchedule) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach { $0.weak?.profileMediatorDidChange(weekSchedule: weekSchedule) }
            
            self?.weekScheduleChangeTrigger.accept(weekSchedule)
        }
    }
    
    func notify(drillsIds: [Int]) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach { $0.weak?.profileMediatorDidChange(drillsIds: drillsIds) }
            
            self?.drillsIdsChangeTrigger.accept(drillsIds)
        }
    }
    
    func notify(focusZones: [FocusZone]) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach { $0.weak?.profileMediatorDidChange(focusZones: focusZones) }
            
            self?.focusZonesChangeTrigger.accept(focusZones)
        }
    }
}

// MARK: Public (Rx)
extension ProfileMediator {
    var skillLevelChange: Signal<SkillLevel> {
        skillLevelChangeTrigger.asSignal()
    }
    
    var weekScheduleChange: Signal<WeekSchedule> {
        weekScheduleChangeTrigger.asSignal()
    }
    
    var drillsIdsChange: Signal<[Int]> {
        drillsIdsChangeTrigger.asSignal()
    }
    
    var focusZonesChange: Signal<[FocusZone]> {
        focusZonesChangeTrigger.asSignal()
    }
}

// MARK: Public (Observer)
extension ProfileMediator {
    func add(delegate: ProfileMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ProfileMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(delegate: ProfileMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
