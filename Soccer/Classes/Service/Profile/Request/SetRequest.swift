//
//  SetRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 28.08.2022.
//

import Alamofire

struct SetRequest: APIRequestBody {
    let userToken: String
    let skillLevel: Int?
    let weekSchedule: [String: Bool]?
    let drills: [Int]?
    let focusZones: [Int]?
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
        
        if let skillLevel = skillLevel {
            params["skill_level"] = skillLevel
        }
        
        if let weekSchedule = weekSchedule {
            params["week_schedule"] = weekSchedule
        }
        
        if let drills = drills {
            params["drills"] = drills
        }
        
        if let focusZones = focusZones {
            params["focus_zones"] = focusZones
        }
        
        return params
    }
}
