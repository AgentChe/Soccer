//
//  WorkoutTrainingView.swift
//  Soccer
//
//  Created by Виталий Загороднов on 23.03.2023.
//

import UIKit

class WorkoutTrainingView: UIView {
    
    lazy var closeButton = makeCloseButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WorkoutTrainingView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension WorkoutTrainingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 36.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 36.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 54.scale : 34.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WorkoutTrainingView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "DrillTraining.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
