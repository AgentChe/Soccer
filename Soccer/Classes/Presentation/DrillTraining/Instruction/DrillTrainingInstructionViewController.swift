//
//  DrillTrainingInstructionViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 09.02.2023.
//

import UIKit
import RxSwift

final class DrillTrainingInstructionViewController: UIViewController {
    lazy var mainView = DrillTrainingInstructionView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = DrillTrainingInstructionViewModel(drillTraining: drillTraining)
    
    private let drillTraining: DrillTraining
    
    private init(drillTraining: DrillTraining) {
        self.drillTraining = drillTraining
        
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
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension DrillTrainingInstructionViewController {
    static func make(drillTraining: DrillTraining) -> DrillTrainingInstructionViewController {
        let vc = DrillTrainingInstructionViewController(drillTraining: drillTraining)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: DTITableDelegate
extension DrillTrainingInstructionViewController: DTITableDelegate {
    func dtiTableDidTappedCalendar() {
        // TODO
        print("dtiTableDidTappedCalendar")
    }
    
    func dtiTableDidTappedStartTraining() {
        let vc = DrillTrainingViewController.make(drillTraining: drillTraining)
        present(vc, animated: true)
    }
}
