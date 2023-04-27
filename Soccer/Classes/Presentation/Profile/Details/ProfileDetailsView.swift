//
//  ProfileDetailsView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import UIKit

class ProfileDetailsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ProfileDetailsView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension ProfileDetailsView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension ProfileDetailsView {
    func makeTableView() -> ProfileMainTableView {
        let view = ProfileMainTableView()
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
