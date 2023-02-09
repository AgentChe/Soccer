//
//  HomeViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 06.02.2023.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    lazy var mainView = HomeView()
    
    private lazy var viewModel = HomeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension HomeViewController {
    static func make() -> HomeViewController {
        let vc = HomeViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: HomeTableViewDelegate
extension HomeViewController: HomeTableViewDelegate {
    func homeTableDidTap(drillTraining: DrillTraining) {
        let vc = DrillTrainingInstructionViewController.make(drillTraining: drillTraining)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func homeTableDidTap(workout: WorkoutTrainingCover) {
        // TODO
        print("homeTableDidTap workout: \(workout.name)")
    }
    
    func homeTableDidTap(drill: Drill) {
        // TODO
        print("homeTableDidTap drill: \(drill.name)")
    }
    
    func homeTableDidTapTryDrills() {
        // TODO
        print("homeTableDidTapTryDrills")
    }
    
    func homeTableDidTapWorkouts() {
        // TODO
        print("homeTableDidTapWorkouts")
    }
}

// MARK: Private
private extension HomeViewController {
    func activity(_ activity: Bool) {
        mainView.tableView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
