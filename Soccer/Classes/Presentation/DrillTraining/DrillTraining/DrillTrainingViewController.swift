//
//  DrillTrainingViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit
import RxSwift

final class DrillTrainingViewController: UIViewController {
    lazy var mainView = DrillTrainingView(drill: drill)
    
    private lazy var viewModel = DrillTrainingViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var lifeCyrcle = DrillTrainingLifeCyrcle()
    
    private let drill: Drill
    
    private init(drill: Drill) {
        self.drill = drill
        
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
            .bind(to: Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
        
        lifeCyrcle.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension DrillTrainingViewController {
    static func make(drill: Drill) -> DrillTrainingViewController {
        let vc = DrillTrainingViewController(drill: drill)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: DrillTrainingLifeCyrcleDelegate
extension DrillTrainingViewController: DrillTrainingLifeCyrcleDelegate {
    func drillTrainingPrepare() {
        
    }
    
    func drillTrainingReadyIn(seconds: Int) {
        
    }
    
    func drillTrainingPrepared() {
        
    }
    
    func drillTrainingDidStart() {
        
    }
    
    func drillTrainingTick(seconds: Int) {
        
    }
    
    func drillTrainigPaused() {
        
    }
    
    func drillTrainingStopped() {
        
    }
}

// MARK: Private
private extension DrillTrainingViewController {
    func dismiss() {
        dismiss(animated: true)
    }
}
