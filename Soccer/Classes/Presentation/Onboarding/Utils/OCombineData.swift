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
}

final class OnboardingCombineData {
    private var skillLevel: SkillLevel?
    private var weekSchedule: WeekSchedule?
    
    func combineData() -> OCombineData? {
        guard
            let skillLevel = skillLevel?.code,
            let weekSchedule = weekSchedule
        else {
            return nil
        }

        return OCombineData(
            skillLevel: skillLevel,
            weekSchedule: weekSchedule
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
