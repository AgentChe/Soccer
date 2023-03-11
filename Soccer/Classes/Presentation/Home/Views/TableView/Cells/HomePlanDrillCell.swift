//
//  HomePlanDrillCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2023.
//

import UIKit
import Kingfisher

final class HomePlanDrillCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var pictureView = makeImageView()
    lazy var drillTypeLabel = makeLabel(numberOfLines: 1)
    lazy var nameLabel = makeLabel(numberOfLines: 2)
    lazy var skillLevelLabel = makeLabel(numberOfLines: 1)
    
    private lazy var drillTypeAttrs = TextAttributes()
        .textColor(Appearance.primary)
        .font(Fonts.Inter.regular(size: 12.scale))
        .lineHeight(15.6.scale)
        .letterSpacing(0.41.scale)
        .textAlignment(.left)
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(20.8.scale)
        .textAlignment(.left)
    private lazy var skillLevelAttrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.5))
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(18.2.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension HomePlanDrillCell {
    func setup(element: HomePlanDrillElement) {
        pictureView.kf.setImage(with: element.planDrill.image)
        
        drillTypeLabel.attributedText = element.drillCategory.name.attributed(with: drillTypeAttrs)
        nameLabel.attributedText = element.planDrill.name.attributed(with: nameAttrs)
        skillLevelLabel.attributedText = element.skillLevel.name.attributed(with: skillLevelAttrs)
    }
}

// MARK: Private
private extension HomePlanDrillCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension HomePlanDrillCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 90.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 90.scale),
            pictureView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            pictureView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            drillTypeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 122.scale),
            drillTypeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            drillTypeLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 122.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            skillLevelLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 122.scale),
            skillLevelLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            skillLevelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomePlanDrillCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.black
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel(numberOfLines: Int) -> UILabel {
        let view = UILabel()
        view.numberOfLines = numberOfLines
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
