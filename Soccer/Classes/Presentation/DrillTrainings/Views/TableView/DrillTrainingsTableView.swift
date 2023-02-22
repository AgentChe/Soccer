//
//  DrillTrainingsTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit

protocol DrillTrainingsTableDelegate: AnyObject {
    func drillTrainingsTableDidTap(element: DrillTrainingsTableElement)
}

final class DrillTrainingsTableView: UITableView {
    weak var mainDelegate: DrillTrainingsTableDelegate?
    
    lazy var elements = [DrillTrainingsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DrillTrainingsTableView {
    func setup(elements: [DrillTrainingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension DrillTrainingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: DrillTrainingsTableCell.self)) as! DrillTrainingsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension DrillTrainingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        mainDelegate?.drillTrainingsTableDidTap(element: element)
    }
}

// MARK: Private
private extension DrillTrainingsTableView {
    func initialize() {
        register(DrillTrainingsTableCell.self, forCellReuseIdentifier: String(describing: DrillTrainingsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
