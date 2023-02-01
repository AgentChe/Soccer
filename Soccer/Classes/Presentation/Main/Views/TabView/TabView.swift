//
//  TabView.swift
//  Manga
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case home, train, profile
    }
    
    lazy var homeItem = makeItem(name: "Main.Home")
    lazy var trainItem = makeItem(name: "Main.Train")
    lazy var profileItem = makeItem(name: "Main.Profile")
    
    var selectedTab = Tab.home {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func update() {
        [
            homeItem,
            trainItem,
            profileItem
        ]
        .forEach {
            $0.mode = .deselected
        }
        
        switch selectedTab {
        case .home:
            homeItem.mode = .selected
        case .train:
            trainItem.mode = .selected
        case .profile:
            profileItem.mode = .selected
        }
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            homeItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            homeItem.topAnchor.constraint(equalTo: topAnchor),
            homeItem.widthAnchor.constraint(equalTo: trainItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            trainItem.leadingAnchor.constraint(equalTo: homeItem.trailingAnchor),
            trainItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            trainItem.topAnchor.constraint(equalTo: topAnchor),
            trainItem.widthAnchor.constraint(equalTo: profileItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profileItem.leadingAnchor.constraint(equalTo: trainItem.trailingAnchor),
            profileItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileItem.topAnchor.constraint(equalTo: topAnchor),
            profileItem.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeItem(name: String) -> TabItemView {
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.semiBold(size: 12.scale))
            .textColor(Appearance.black)
            .lineHeight(12.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        let view = TabItemView()
        view.backgroundColor = UIColor.clear
        view.iconView.image = UIImage(named: name)
        view.label.attributedText = name.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
