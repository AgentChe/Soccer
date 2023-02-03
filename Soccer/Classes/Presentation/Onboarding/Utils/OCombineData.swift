//
//  OCombineData.swift
//  Wicca
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import Foundation

struct OCombineData {
    let skillLevel: Int
    let weekSchedule: WeekSchedule
    let drills: [Int]
    let focusZones: [Int]
}

final class OnboardingCombineData {
    private var skillLevel: SkillLevel?
    private var weekSchedule: WeekSchedule?
    private var drills: [Drill]?
    private var focusZones: [FocusZone]?
    
    func combineData() -> OCombineData? {
        guard
            let skillLevel = skillLevel?.code,
            let weekSchedule = weekSchedule,
            let drills = drills,
            let focusZones = focusZones
        else {
            return nil
        }

        return OCombineData(
            skillLevel: skillLevel,
            weekSchedule: weekSchedule,
            drills: drills.map { $0.id },
            focusZones: focusZones.map { $0.code }
        )
    }
}

// MARK: OSkillLevelViewDelegate
extension OnboardingCombineData: OSkillLevelViewDelegate {
    func skillLevelViewDidSelect(skillLevel: SkillLevel) {
        self.skillLevel = skillLevel
    }
}

// MARK: ODaysOfWeekViewDelegate
extension OnboardingCombineData: ODaysOfWeekViewDelegate {
    func daysOfWeekViewDidSelect(weekSchedule: WeekSchedule) {
        self.weekSchedule = weekSchedule
    }
}

// MARK: ODrillsViewDelegate
extension OnboardingCombineData: ODrillsViewDelegate {
    func drillsViewDidSelect(drills: [Drill]) {
        self.drills = drills
    }
}

// MARK: OFocusZoneViewDelegate
extension OnboardingCombineData: OFocusZoneViewDelegate {
    func focusZoneDidSelect(focusZones: [FocusZone]) {
        self.focusZones = focusZones
    }
}
