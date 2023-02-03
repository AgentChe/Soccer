//
//  GetDrillsResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

final class GetDrillsResponse {
    static func map(from response: Any) -> [Drill] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
        
        return data.compactMap { drillJSON -> Drill? in
            guard
                let id = drillJSON["id"] as? Int,
                let name = drillJSON["name"] as? String
            else {
                return nil
            }
            
            return Drill(id: id,
                         name: name)
        }
    }
}
