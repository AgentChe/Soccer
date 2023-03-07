//
//  GetDrillTrainingsRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Alamofire

struct GetDrillTrainingsRequest: APIRequestBody {
    let userToken: String
    let drillId: Int
    let levelId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/drills/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "drill_category_id": drillId,
            "level_id": levelId
        ]
    }
}
