//
//  PaygateProductButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateProductButton: UIButton {
    var isChecked: Bool = false {
        didSet {
            update()
        }
    }
    
    var product: PaygateProduct? {
        didSet {
            update()
        }
    }
    
    lazy var checkedView = makeCheckedView()
    lazy var nameLabel = makeLabel()
    lazy var priceLabel = makeLabel()
    lazy var discountPlaceholderView = makeDiscountPlaceholderView()
    lazy var discountLabel = makeLabel()
    lazy var bottomLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateProductButton {
    func update() {
        changeSelection()
        configure()
    }
    
    func changeSelection() {
        layer.borderWidth = isChecked ? 2.scale : 0
        layer.borderColor = isChecked ? Appearance.white.cgColor : UIColor.clear.cgColor
        
        checkedView.isHidden = !isChecked
    }
    
    func configure() {
        guard let info = product?.info else {
            return
        }
        
        nameLabel.attributedText = info.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.white)
                            .font(Fonts.Inter.bold(size: 20.scale))
                            .lineHeight(24.scale))
        
        let slash = "/".attributed(with: TextAttributes()
                                .textColor(Appearance.white)
                                .font(Fonts.Inter.semiBold(size: 22.scale))
                                .lineHeight(22.scale)
                                .letterSpacing(-1.scale))
        
        let priceValue = info.price.attributed(with: TextAttributes()
                                .textColor(Appearance.white)
                                .font(Fonts.Inter.semiBold(size: 22.scale))
                                .lineHeight(22.scale)
                                .letterSpacing(-1.scale))
        let pricePeriod = info.pricePeriod.attributed(with: TextAttributes()
                                .textColor(Appearance.white)
                                .font(Fonts.Inter.regular(size: 12.scale))
                                .lineHeight(12.scale))
        let priceDescription = info.priceDescription?.attributed(with: TextAttributes()
                                .textColor(Appearance.white)
                                .font(Fonts.Inter.regular(size: 12.scale))
                                .lineHeight(12.scale))
        let price = NSMutableAttributedString()
        price.append(priceValue)
        price.append(slash)
        price.append(pricePeriod)
        if let priceDescription = priceDescription {
            price.append(priceDescription)
        }
        priceLabel.attributedText = price
        
        discountPlaceholderView.isHidden = info.discount == nil
        discountLabel.isHidden = info.discount == nil
        if let discount = info.discount {
            discountLabel.attributedText = String(format: "Paygate.Discount".localized, discount)
                .attributed(with: TextAttributes()
                                .textColor(Appearance.white)
                                .font(Fonts.Inter.bold(size: 14.scale))
                                .lineHeight(16.8.scale))
        }
        
        let bottomPrice = info.bottomPrice?.attributed(with: TextAttributes()
                                .textColor(Appearance.white)
                                .font(Fonts.Inter.semiBold(size: 22.scale))
                                .lineHeight(30.8.scale)
                                .letterSpacing(-1.scale))
        let bottomDescription = info.bottomDescription.attributed(with: TextAttributes()
                                .textColor(Appearance.white)
                                .font(Fonts.Inter.regular(size: 12.scale))
                                .lineHeight(16.8.scale))
        let bottom = NSMutableAttributedString()
        if let bottomPrice = bottomPrice {
            bottom.append(bottomPrice)
            bottom.append(slash)
        }
        bottom.append(bottomDescription)
        bottomLabel.attributedText = bottom
    }
}

// MARK: Make constraints
private extension PaygateProductButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            checkedView.topAnchor.constraint(equalTo: topAnchor, constant: 13.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 34.scale)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 66.scale)
        ])
        
        NSLayoutConstraint.activate([
            discountPlaceholderView.widthAnchor.constraint(equalToConstant: 74.scale),
            discountPlaceholderView.heightAnchor.constraint(equalToConstant: 23.scale),
            discountPlaceholderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            discountPlaceholderView.topAnchor.constraint(equalTo: topAnchor, constant: 114.scale)
        ])
        
        NSLayoutConstraint.activate([
            discountLabel.centerXAnchor.constraint(equalTo: discountPlaceholderView.centerXAnchor),
            discountLabel.centerYAnchor.constraint(equalTo: discountPlaceholderView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateProductButton {
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Checked")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDiscountPlaceholderView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary
        view.layer.cornerRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
