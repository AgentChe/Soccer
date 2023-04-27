//
//  ProfileMainStatsCell.swift
//  Soccer
//
//  Created by Виталий Загороднов on 27.04.2023.
//

import UIKit

class ProfileMainStatsCell: UITableViewCell {
    
    private lazy var titlelabel = makeLabel()
    private lazy var scrollView = makeScrollView()
    private lazy var drillStats = makeStatsView()
    private lazy var workoutStats = makeStatsView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileMainStatsCell {
    func setup(drillValue: String, workoutValue: String) {
        drillStats.setup(value: drillValue, subtitle: "Profile.Completed.Drills".localized)
        workoutStats.setup(value: workoutValue, subtitle: "Profile.Completed.Workouts".localized)
    }
}

// MARK: Private
private extension ProfileMainStatsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ProfileMainStatsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titlelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titlelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 16.scale),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            drillStats.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            drillStats.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            drillStats.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            workoutStats.leadingAnchor.constraint(equalTo: drillStats.trailingAnchor, constant: 10.scale),
            workoutStats.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            workoutStats.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            workoutStats.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileMainStatsCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        view.attributedText = "Profile.StatsTitle".localized.attributed(with: attrs)
        contentView.addSubview(view)
        return view
    }
    
    func makeStatsView() -> ProfileMainStatsView {
        let view = ProfileMainStatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        contentView.addSubview(view)
        return view
    }
}
