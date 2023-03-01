//
//  GetFocusZonesResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.03.2023.
//

final class GetFocusZonesResponse {
    static func map(from response: Any) -> [FocusZone] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let focusZonesArray = data["body_parts"] as? [[String: Any]]
        else {
            return []
        }
        
        return focusZonesArray.compactMap { focusZoneJSON -> FocusZone? in
            guard
                let id = focusZoneJSON["body_part_id"] as? Int,
                let name = focusZoneJSON["name"] as? String
            else {
                return nil
            }
            
            return FocusZone(
                id: id,
                name: name
            )
        }
    }
}
