//
//  PaygateViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import RxSwift
import RxCocoa
import OtterScaleiOS

final class PaygateViewModel {
    let buy = PublishRelay<String>()
    let restore = PublishRelay<Void>()
    
    lazy var products = makeProducts()
    lazy var buyed = makeBuyed()
    lazy var restored = makeRestored()
    
    let activityIndicator = RxActivityIndicator()
    
    private lazy var prices = makePrices()
    private lazy var paygate = makePaygate()
    
    private lazy var iapManager = IAPManager()
    private lazy var purchaseInteractor = PaygateInteractor()
    private lazy var paygateManager = PaygateManager()
}

// MARK: Private
private extension PaygateViewModel {
    func makeProducts() -> Driver<[PaygateProduct]> {
        Driver
            .combineLatest(paygate, prices)
            .map { paygate, prices -> [PaygateProduct] in
                prices.compactMap { price -> PaygateProduct? in
                    switch price.id {
                    case paygate.lifetime:
                        let lifetimePrice = prices.first(where: { $0.id == paygate.lifetime })
                        let monthlyPrice = prices.first(where: { $0.id == paygate.monthly })
                        
                        guard let lifetimePrice = lifetimePrice, let monthlyPrice = monthlyPrice else {
                            return nil
                        }
                        
                        return PaygateProduct.lifetime(lifetimePrice: lifetimePrice, monthlyPrice: monthlyPrice)
                    case paygate.monthly:
                        let usedProducts = OtterScale.shared.getUsedProducts()
                            .map { $0.appleAppStore } ?? []
                        let withTrial = !usedProducts.contains(paygate.monthly)
                        
                        return PaygateProduct.monthly(price: price, withTrial: withTrial)
                    default:
                        return nil
                    }
                }
            }
            .trackActivity(activityIndicator)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeBuyed() -> Signal<Bool> {
        let purchase = buy
            .flatMapLatest { [weak self] productId -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.purchaseInteractor
                    .makeActiveSubscription(by: .buy(productId))
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(self.activityIndicator)
                    .catchAndReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
    
    func makeRestored() -> Signal<Bool> {
        let purchase = restore
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.purchaseInteractor
                    .makeActiveSubscription(by: .restore)
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(self.activityIndicator)
                    .catchAndReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
    
    func makePrices() -> Driver<[ProductPrice]> {
        paygate
            .flatMapLatest { [weak self] paygate -> Driver<[ProductPrice]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.iapManager
                    .obtainPrices(for: [paygate.monthly, paygate.lifetime])
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makePaygate() -> Driver<Paygate> {
        paygateManager
            .obtainPaygate(forceUpdate: false)
            .asDriver(onErrorDriveWith: .never())
    }
}
