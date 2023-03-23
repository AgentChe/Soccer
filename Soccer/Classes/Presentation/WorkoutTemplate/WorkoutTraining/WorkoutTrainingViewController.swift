//
//  WorkoutTrainingViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import UIKit
import RxSwift

class WorkoutTrainingViewController: UIViewController {
    lazy var mainView = WorkoutTrainingView()
    
    private let viewModel: WorkoutTrainingViewModel
    
    private lazy var disposeBag = DisposeBag()

    private init(customerWorkoutId: Int) {
        viewModel = .init(customerWorkoutId: customerWorkoutId)
        
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
        mainView.closeButton.rx.tap
            .asSignal()
            .emit(with: self) { base, _ in
                base.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension WorkoutTrainingViewController {
    static func make(customerWorkoutId: Int) -> WorkoutTrainingViewController {
        let vc = WorkoutTrainingViewController(customerWorkoutId: customerWorkoutId)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
