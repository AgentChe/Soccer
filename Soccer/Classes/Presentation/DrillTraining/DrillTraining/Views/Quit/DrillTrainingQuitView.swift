//
//  DrillTrainingQuitView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 22.02.2023.
//

//import UIKit
//
//final class DrillTrainingQuitView: UIView {
//    lazy var dimmedView = makeDimmedView()
//    lazy var container = makeContainer()
//    lazy var closeButton = makeCloseButton()
//    lazy var deleteButton = makeButton(title: "Library.Delete".localized,
//                                       imageName: "Library.Delete")
//    lazy var separator = makeSeparator()
//    lazy var shareButton = makeButton(title: "Library.Share".localized,
//                                       imageName: "Library.Share")
//
//    lazy var containerBottomConstraint = NSLayoutConstraint()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        makeConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: Make constraints
//private extension DrillTrainingQuitView {
//    func makeConstraints() {
//        NSLayoutConstraint.activate([
//            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            dimmedView.topAnchor.constraint(equalTo: topAnchor)
//        ])
//
//        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 256.scale)
//        NSLayoutConstraint.activate([
//            container.leadingAnchor.constraint(equalTo: leadingAnchor),
//            container.trailingAnchor.constraint(equalTo: trailingAnchor),
//            containerBottomConstraint,
//            container.heightAnchor.constraint(equalToConstant: 256.scale)
//        ])
//
//        NSLayoutConstraint.activate([
//            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
//            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
//            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18.scale),
//            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 26.scale)
//        ])
//
//        NSLayoutConstraint.activate([
//            deleteButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
//            deleteButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 74.scale)
//        ])
//
//        NSLayoutConstraint.activate([
//            separator.widthAnchor.constraint(equalToConstant: 343.scale),
//            separator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
//            separator.heightAnchor.constraint(equalToConstant: 1.scale),
//            separator.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 20.scale)
//        ])
//
//        NSLayoutConstraint.activate([
//            shareButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
//            shareButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20.scale)
//        ])
//    }
//}
//
//// MARK: Lazy initialization
//private extension DrillTrainingQuitView {
//    func makeDimmedView() -> UIView {
//        let view = UIView()
//        view.alpha = 0
//        view.backgroundColor = UIColor.black
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//        return view
//    }
//
//    func makeContainer() -> UIView {
//        let view = UIView()
//        view.backgroundColor = Appearance.black
//        view.layer.cornerRadius = 12.scale
//        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//        return view
//    }
//
//    func makeContinueButton() -> UIButton {
//        let attrs = TextAttributes()
//            .textColor(Appearance.white)
//            .font(Fonts.Inter.semiBold(size: 16.scale))
//            .lineHeight(19.2.scale)
//            .textAlignment(.center)
//
//        let view = UIButton()
//        view.setAttributedTitle("DrillTraining.ConfirmFinish.Continue".localized.attributed(with: attrs), for: .normal)
//        view.backgroundColor = Appearance.primary
//        view.layer.cornerRadius = 8.scale
//        view.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(view)
//        return view
//    }
//
//    func makeQuitButton() -> UIButton {
//        let attrs = TextAttributes()
//            .textColor(Appearance.white)
//            .font(Fonts.Inter.semiBold(size: 16.scale))
//            .lineHeight(19.2.scale)
//            .textAlignment(.center)
//
//        let view = UIButton()
//        view.setAttributedTitle("DrillTraining.ConfirmFinish.Continue".localized.attributed(with: attrs), for: .normal)
//        view.backgroundColor = Appearance.primary
//        view.layer.cornerRadius = 8.scale
//        view.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(view)
//        return view
//    }
//}
