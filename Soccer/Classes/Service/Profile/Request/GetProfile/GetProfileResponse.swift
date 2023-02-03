//
//  GetProfileResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

final class GetProfileResponse {
    static func map(from response: Any) -> Profile? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        let skillLevelCode = data["skill_level"] as? Int ?? -1
        let skillLevel = SkillLevel(code: skillLevelCode)
        
        let drillsIds = data["drills"] as? [Int]
        
        let weekScheduleJSON = data["week_schedule"] as? [String: Bool] ?? [:]
        let weekSchedule = WeekSchedule(su: weekScheduleJSON["su"] ?? false,
                                        mo: weekScheduleJSON["mo"] ?? false,
                                        tu: weekScheduleJSON["tu"] ?? false,
                                        we: weekScheduleJSON["we"] ?? false,
                                        th: weekScheduleJSON["th"] ?? false,
                                        fr: weekScheduleJSON["fr"] ?? false,
                                        sa: weekScheduleJSON["sa"] ?? false)
        
        let focusZonesCodes = data["focus_zones"] as? [Int]
        let focusZones = focusZonesCodes?.compactMap { FocusZone(code: $0) }
        
        return Profile(skillLevel: skillLevel,
                       weekSchedule: weekSchedule,
                       drillsIds: drillsIds,
                       focusZones: focusZones)
    }
}
