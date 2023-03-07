//
//  DrillManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.03.2023.
//

import RxSwift

protocol DrillManagerProtocol {
    func obtainDrillCategories(forceUpdate: Bool) -> Single<[DrillCategory]>
    func obtainDrillTrainings(at drillId: Int) -> Single<[DrillTraining]>
}

// TODO: удалить Mocks folder
final class DrillManager {
    enum Constants {
        static let drillCategoriesKey = "content_manager_drill_categories_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: DrillManagerProtocol
extension DrillManager: DrillManagerProtocol {
    func obtainDrillCategories(forceUpdate: Bool) -> Single<[DrillCategory]> {
        forceUpdate ? loadDrillCategories() : cachedDrillCategories()
    }
    
    // TODO
    func obtainDrillTrainings(at drillId: Int) -> Single<[DrillTraining]> {
        Single<[DrillTraining]>.create { event in
            let url = Bundle.main.url(forResource: "DrillTrainings", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let result = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            let drillTrainings = GetDrillTrainingsResponse.map(from: result)
            event(.success(drillTrainings))
            
            return Disposables.create()
        }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetDrillTrainingsRequest(userToken: userToken,
//                                               id: drillId)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetDrillTrainingsResponse.map(from: $0) }
    }
}

// MARK: Private
private extension DrillManager {
    func loadDrillCategories() -> Single<[DrillCategory]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetDrillCategoriesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetDrillCategoriesResponse.map(from: $0) }
            .do(onSuccess: { drills in
                guard let data = try? JSONEncoder().encode(drills) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.drillCategoriesKey)
            })
    }
    
    func cachedDrillCategories() -> Single<[DrillCategory]> {
        Single<[DrillCategory]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.drillCategoriesKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let drillCategories = try? JSONDecoder().decode([DrillCategory].self, from: data)
                
                event(.success(drillCategories ?? []))
                
                return Disposables.create()
            }
    }
}
