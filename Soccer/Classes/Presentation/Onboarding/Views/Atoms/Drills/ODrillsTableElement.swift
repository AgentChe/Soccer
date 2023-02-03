//
//  ODrillsTableElement.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

final class ODrillsTableElement {
    let drill: Drill
    var marked: Bool
    
    init(drill: Drill, marked: Bool = false) {
        self.drill = drill
        self.marked = marked
    }
}
