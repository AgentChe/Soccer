//
//  PaygatePrice.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import Foundation

struct PaygateProduct {
    enum `Type` {
        case lifetime, monthly
    }

    let type: Type
    let price: ProductPrice
    let info: PaygateProductInfo
}

// MARK: Make
extension PaygateProduct {
    static func lifetime(lifetimePrice: ProductPrice, monthlyPrice: ProductPrice) -> PaygateProduct {
        let formatter = formatter(locale: lifetimePrice.priceLocale)
        
        let priceDiv: Double = lifetimePrice.priceValue / 12
        let priceDivLocalized: String
        if priceDiv < 100 {
            formatter.maximumFractionDigits = 1
            priceDivLocalized = formatter.string(from: NSNumber(value: (priceDiv * 10).rounded() / 10)) ?? ""
        } else {
            formatter.maximumFractionDigits = 0
            priceDivLocalized = formatter.string(from: NSNumber(value: round(priceDiv))) ?? ""
        }
        let pricePeriodResult = priceDivLocalized.removingWhitespaces()
        
        formatter.maximumFractionDigits = lifetimePrice.priceValue.truncatingRemainder(dividingBy: 1) > 0 ? 2 : 0
        let priceLocalized = formatter.string(from: NSNumber(value: lifetimePrice.priceValue)) ?? ""
        let priceResult = priceLocalized.removingWhitespaces()
        
        let diff = monthlyPrice.priceValue - priceDiv
        let discount = 100 / (monthlyPrice.priceValue / diff)
         
        let info = PaygateProductInfo(name: "Paygate.Lifetime.Name".localized,
                                      price: pricePeriodResult,
                                      pricePeriod: "Paygate.Price.Period".localized,
                                      priceDescription: "Paygate.Lifetime.PriceDescription".localized,
                                      discount: Int(discount),
                                      bottomPrice: priceResult,
                                      bottomDescription: "Paygate.Lifetime.BottomDescription".localized)
        
        return PaygateProduct(type: .lifetime,
                              price: lifetimePrice,
                              info: info)
    }
    
    static func monthly(price: ProductPrice, withTrial: Bool) -> PaygateProduct {
        let formatter = formatter(locale: price.priceLocale)
        formatter.maximumFractionDigits = price.priceValue.truncatingRemainder(dividingBy: 1) > 0 ? 2 : 0
        
        let priceLocalized = formatter.string(from: NSNumber(value: price.priceValue)) ?? ""
        let priceResult = priceLocalized.removingWhitespaces()
        
        let info = PaygateProductInfo(name: withTrial ? "Paygate.Monthly.Name1".localized : "Paygate.Monthly.Name2".localized,
                                      price: priceResult,
                                      pricePeriod: "Paygate.Price.Period".localized,
                                      priceDescription: nil,
                                      discount: nil,
                                      bottomPrice: nil,
                                      bottomDescription: withTrial ? "Paygate.Monthly.Bottom1".localized : "Paygate.Monthly.Bottom2".localized)
        
        return PaygateProduct(type: .monthly,
                              price: price,
                              info: info)
    }
}

// MARK: Private
private extension PaygateProduct {
    static func formatter(locale: Locale) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter
    }
}
