//
//  DrillTrainingInstructionView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit

final class DrillTrainingInstructionView: UIView {
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension DrillTrainingInstructionView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension DrillTrainingInstructionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DrillTrainingInstructionView {
    func makeTableView() -> DTITableView {
        let view = DTITableView()
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24.scale, right: 0)
        view.setContentOffset(CGPoint.zero, animated: false)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
