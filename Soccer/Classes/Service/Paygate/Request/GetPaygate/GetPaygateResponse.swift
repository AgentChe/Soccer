//
//  GetPaygateResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 27.12.2022.
//

final class GetPaygateResponse {
    static func map(from response: Any) throws -> Paygate {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let monthly = data["month"] as? String,
            let lifetime = data["lifetime"] as? String
        else {
            throw ContentError(.notContent)
        }
        
        return Paygate(monthly: monthly,
                       lifetime: lifetime)
    }
}
