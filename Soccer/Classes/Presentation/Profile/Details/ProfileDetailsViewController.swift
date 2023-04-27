//
//  ProfileDetailsViewController.swift
//  Soccer
//
//  Created by Виталий Загороднов on 25.04.2023.
//

import UIKit

class ProfileDetailsViewController: UIViewController {
    
    lazy var mainView = ProfileDetailsView()
    
    private let viewModel: ProfileDetailsViewModel = .init()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ProfileDetailsViewController {
    func make() -> ProfileDetailsViewController {
        ProfileDetailsViewController()
    }
}
