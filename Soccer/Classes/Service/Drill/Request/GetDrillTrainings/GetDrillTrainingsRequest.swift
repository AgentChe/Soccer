//
//  GetDrillTrainingsRequest.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import Alamofire

struct GetDrillTrainingsRequest: APIRequestBody {
    let userToken: String
    let id: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/drill_trainings"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "drill_id": id
        ]
    }
}
