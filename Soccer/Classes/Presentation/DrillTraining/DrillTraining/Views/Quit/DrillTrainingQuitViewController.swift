//
//  DrillTrainingQuitViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class LibraryBookMenuViewController: UIViewController {
    enum Result {
        case delete
        case share
    }
    
    lazy var mainView = LibraryBookMenuView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let completion: (Result) -> Void
    
    private init(completion: @escaping (Result) -> Void) {
        self.completion = completion
        
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
                base.dismiss(result: nil)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.deleteButton.rx.tap
                    .map { Result.delete },
                
                mainView.shareButton.rx.tap
                    .map { Result.share }
            )
            .bind(to: Binder(self) { base, result in
                base.dismiss(result: result)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShow()
    }
}

// MARK: Make
extension LibraryBookMenuViewController {
    static func make(completion: @escaping (Result) -> Void) -> LibraryBookMenuViewController {
        let vc = LibraryBookMenuViewController(completion: completion)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension LibraryBookMenuViewController {
    func animateShow() {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 0
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.2
            self?.mainView.layoutIfNeeded()
        })
    }
    
    func dismiss(result: Result?) {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                if let result = result {
                    self?.completion(result)
                }
            }
        }
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 256.scale
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
