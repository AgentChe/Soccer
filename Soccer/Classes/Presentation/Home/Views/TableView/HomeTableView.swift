//
//  HomeTableView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit

protocol HomeTableViewDelegate: AnyObject {
    func homeTableDidTap(drill: Drill)
    func homeTableDidTap(workout: WorkoutCover)
    func homeTableDidTap(drillCategory: DrillCategory)
    func homeTableDidTapTryDrills()
    func homeTableDidTapWorkouts()
}

final class HomeTableView: UITableView {
    weak var mainDelegate: HomeTableViewDelegate?
    
    lazy var elements = [HomeTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeTableView {
    func setup(elements: [HomeTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension HomeTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeTitleCell.self)) as! HomeTitleCell
            cell.setup(element: element)
            return cell
        case .dailyPicks(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: DailyPicksTableCell.self)) as! DailyPicksTableCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didTap = { [weak self] dailyPicks in
                switch dailyPicks {
                case .drill(let drill):
                    self?.mainDelegate?.homeTableDidTap(drill: drill)
                case .workout(let workout):
                    self?.mainDelegate?.homeTableDidTap(workout: workout)
                }
            }
            return cell
        case .drillCategories(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeDrillsCell.self)) as! HomeDrillsCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didTap = { [weak self] drillCategory in
                self?.mainDelegate?.homeTableDidTap(drillCategory: drillCategory)
            }
            return cell
        case .tryDrillsTitle(let element), .workoutsTitle(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SeeAllTableCell.self)) as! SeeAllTableCell
            cell.setup(element: element)
            return cell
        case .drillTraining(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeDrillCoverCell.self)) as! HomeDrillCoverCell
            cell.setup(element: element)
            return cell
        case .workouts(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeWorkoutsCell.self)) as! HomeWorkoutsCell
            cell.collectionView.setup(elements: element)
            cell.collectionView.didTap = { [weak self] workout in
                self?.mainDelegate?.homeTableDidTap(workout: workout)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension HomeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .dailyPicks:
            return 330.scale
        case .drillCategories(let elements):
            guard let drillCategory = elements.first else {
                return 0
            }
            
            return HomeDrillsCollectionCell.size(for: drillCategory).height * 2 + 16.scale
        case .tryDrillsTitle, .workoutsTitle:
            return 30.scale
        case .drillTraining:
            return 90.scale
        case .workouts:
            return 330.scale
        case .title:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .tryDrillsTitle:
            mainDelegate?.homeTableDidTapTryDrills()
        case .workoutsTitle:
            mainDelegate?.homeTableDidTapWorkouts()
        case .drillTraining(let element):
            mainDelegate?.homeTableDidTap(drill: element.drill)
        default:
            return
        }
    }
}

// MARK: Private
private extension HomeTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(HomeTitleCell.self, forCellReuseIdentifier: String(describing: HomeTitleCell.self))
        register(DailyPicksTableCell.self, forCellReuseIdentifier: String(describing: DailyPicksTableCell.self))
        register(HomeDrillsCell.self, forCellReuseIdentifier: String(describing: HomeDrillsCell.self))
        register(SeeAllTableCell.self, forCellReuseIdentifier: String(describing: SeeAllTableCell.self))
        register(HomeDrillCoverCell.self, forCellReuseIdentifier: String(describing: HomeDrillCoverCell.self))
        register(HomeWorkoutsCell.self, forCellReuseIdentifier: String(describing: HomeWorkoutsCell.self))
        
        dataSource = self
        delegate = self
    }
}
