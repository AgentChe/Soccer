//
//  OCombineData.swift
//  Wicca
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import Foundation

struct OCombineData {
    let gender: Int
    let skillLevel: Int
}

final class OnboardingCombineData {
    private var gender: Gender?
    private var skillLevel: SkillLevel?
    
    func combineData() -> OCombineData? {
        guard
            let gender = gender?.code,
            let skillLevel = skillLevel?.code
        else {
            return nil
        }

        return OCombineData(
            gender: gender,
            skillLevel: skillLevel
        )
    }
}

// MARK: OGenderViewDelegate
extension OnboardingCombineData: OGenderViewDelegate {
    func genderViewDidSelect(gender: Gender) {
        self.gender = gender
    }
}

// MARK: OSkillLevelViewDelegate
extension OnboardingCombineData: OSkillLevelViewDelegate {
    func skillLevelViewDidSelect(skillLevel: SkillLevel) {
        self.skillLevel = skillLevel
    }
}
