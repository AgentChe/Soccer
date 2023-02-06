//
//  ContentManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import RxSwift

protocol ContentManagerProtocol {
    func obtainDrills(forceUpdate: Bool) -> Single<[Drill]>
    func obtainHomeKit() -> Single<HomeKit?>
}

// TODO: удалить Mocks folder
final class ContentManager {
    enum Constants {
        static let drillsKey = "content_manager_drills"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ContentManagerProtocol
extension ContentManager {
    // TODO
    func obtainDrills(forceUpdate: Bool) -> Single<[Drill]> {
        Single<[Drill]>.create { event in
            let url = Bundle.main.url(forResource: "Drills", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let result = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            let drills = GetDrillsResponse.map(from: result)
            event(.success(drills))
            
            return Disposables.create()
        }
        
//        forceUpdate ? loadDrills() : cachedDrills()
    }
    
    // TODO
    func obtainHomeKit() -> Single<HomeKit?> {
        Single<HomeKit?>.create { event in
            let url = Bundle.main.url(forResource: "HomeKit", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let result = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            let homeKit = GetHomeKitResponse.map(from: result)
            event(.success(homeKit))
            
            return Disposables.create()
        }
        
//        guard let userToken = sessionManager.getSession()?.userToken else {
//            return .error(SignError.tokenNotFound)
//        }
//
//        let request = GetHomeKitRequest(userToken: userToken)
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: request)
//            .map { GetHomeKitResponse.map(from: $0) }
    }
}

// MARK: Private
private extension ContentManager {
    func loadDrills() -> Single<[Drill]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetDrillsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetDrillsResponse.map(from: $0) }
            .do(onSuccess: { drills in
                guard let data = try? JSONEncoder().encode(drills) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.drillsKey)
            })
    }
    
    func cachedDrills() -> Single<[Drill]> {
        Single<[Drill]>
            .create { event in
                guard let data = UserDefaults.standard.data(forKey: Constants.drillsKey) else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                let drills = try? JSONDecoder().decode([Drill].self, from: data)
                
                event(.success(drills ?? []))
                
                return Disposables.create()
            }
    }
}
