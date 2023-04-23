//
//  CalendarViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 21.04.2023.
//

import UIKit
import RxSwift
import Foundation
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    lazy var mainView = CalendarView()
    
    private let viewModel: CalendarViewModel
    private lazy var disposeBag = DisposeBag()
    
    private var elements: Set<PlanOnDay> = []
    
    private init(schedulerType: CalendarViewModel.SchedulerType) {
        viewModel = .init(schedulerType: schedulerType)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.calendarCollection.calendarDataSource = self
        mainView.calendarCollection.calendarDelegate = self
        mainView.calendarCollection.register(CalendarDateCell.self, forCellWithReuseIdentifier: String(describing: CalendarDateCell.self))
        mainView.calendarCollection.register(CalendarMonthHeader.self, forSupplementaryViewOfKind: "", withReuseIdentifier: String(describing: CalendarMonthHeader.self))

        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.plan
            .drive(with: self) {
                $0.elements = $1
                $0.mainView.calendarCollection.reloadData()
            }
            .disposed(by: disposeBag)
        
        mainView.calendarCollection.scrollToDate(Date(), animateScroll: false)
    }
}

extension CalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let startDate = calendar.date(byAdding: .year, value: -2, to: currentDate) ?? currentDate
        let endDate = calendar.date(byAdding: .year, value: 2, to: currentDate) ?? currentDate
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            firstDayOfWeek: .sunday
        )
    }
}

extension CalendarViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: CalendarDateCell.self), for: indexPath) as! CalendarDateCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarDateCell
        configureCell(cell: cell, cellState: cellState)
    }
    
    func configureCell(cell: CalendarDateCell, cellState: CellState) {
        let calendar = Calendar.current
        let status = elements.first(where: { calendar.compare($0.day, to: cellState.date, toGranularity: .day) == .orderedSame })?.status
        
        cell.isHidden = cellState.dateBelongsTo != .thisMonth
        cell.setup(isCurrentDay: calendar.compare(cellState.date, to: Date(), toGranularity: .day) == .orderedSame)
        cell.setup(status: status, text: cellState.text)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarDateCell
        cell.setup(isSelected: cellState.isSelected)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarDateCell
        cell.setup(isSelected: cellState.isSelected)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: String(describing: CalendarMonthHeader.self), for: indexPath) as! CalendarMonthHeader
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        
        header.setup(title: formatter.string(from: range.start).capitalized)
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return .init(defaultSize: 41.scale)
    }
}

// MARK: Make
extension CalendarViewController {
    static func make(schedulerType: CalendarViewModel.SchedulerType) -> CalendarViewController {
        let vc = CalendarViewController(schedulerType: schedulerType)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension CalendarViewController {
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}
