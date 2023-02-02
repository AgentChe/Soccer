//
//  OSkillLevelView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import UIKit

protocol OSkillLevelViewDelegate: AnyObject {
    func skillLevelViewDidSelect(skillLevel: SkillLevel)
}

final class OSkillLevelView: OSlideView {
    weak var mainDelegate: OSkillLevelViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var beginnerView = makeScoreView(level: .beginner)
    lazy var intermediateView = makeScoreView(level: .intermediate)
    lazy var advancedView = makeScoreView(level: .advanced)
    lazy var slider = makeSlider()
    lazy var continueButton = makeContinueButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        update(sender: slider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSkillLevelView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func update(sender: UISlider) {
        let value = round(sender.value)
        sender.value = value
        
        beginnerView.marked = (value >= 1, value == 1)
        intermediateView.marked = (value >= 2, value == 2)
        advancedView.marked = (value >= 3, value == 3)
    }
    
    @objc
    func nextTapped() {
        let skillLevelCode = Int(self.slider.value) - 1
        
        guard let skillLevel = SkillLevel(code: skillLevelCode) else {
            return
        }
        
        mainDelegate?.skillLevelViewDidSelect(skillLevel: skillLevel)
        
        onNext()
    }
}

// MARK: Make constraints
private extension OSkillLevelView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 140.scale : 140.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            beginnerView.widthAnchor.constraint(equalToConstant: 76.scale),
            beginnerView.heightAnchor.constraint(equalToConstant: 121.scale),
            beginnerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 66.scale),
            beginnerView.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -29.scale)
        ])
        
        NSLayoutConstraint.activate([
            intermediateView.widthAnchor.constraint(equalToConstant: 76.scale),
            intermediateView.heightAnchor.constraint(equalToConstant: 156.scale),
            intermediateView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 150.scale),
            intermediateView.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -29.scale)
        ])
        
        NSLayoutConstraint.activate([
            advancedView.widthAnchor.constraint(equalToConstant: 76.scale),
            advancedView.heightAnchor.constraint(equalToConstant: 208.scale),
            advancedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 234.scale),
            advancedView.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -29.scale)
        ])
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38.scale),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38.scale),
            slider.heightAnchor.constraint(equalToConstant: 20.scale),
            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 363.scale : 363.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 54.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSkillLevelView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.SkillLevel.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScoreView(level: SkillLevel) -> OSkillLevelScoreView {
        let view = OSkillLevelScoreView(level: level)
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlider() -> UISlider {
        let view = UISlider()
        view.minimumValue = 1
        view.maximumValue = 3
        view.thumbTintColor = Appearance.secondary
        view.maximumTrackTintColor = Appearance.white.withAlphaComponent(0.1)
        view.minimumTrackTintColor = Appearance.secondary
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(update(sender:)), for: .valueChanged)
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 8.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
