//
//  ContentManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.02.2023.
//

import RxSwift

protocol ContentManagerProtocol {
    func obtainDrills(forceUpdate: Bool) -> Single<[Drill]>
}

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
        .deferred {
            .just([
                .init(id: 1, name: "Passing"),
                .init(id: 2, name: "Passing"),
                .init(id: 3, name: "Passing"),
                .init(id: 4, name: "Passing"),
                .init(id: 5, name: "Passing"),
                .init(id: 6, name: "Passing"),
                .init(id: 7, name: "Passing"),
                .init(id: 8, name: "Passing"),
                .init(id: 9, name: "Passing"),
                .init(id: 10, name: "Passing"),
                .init(id: 11, name: "Passing"),
                .init(id: 12, name: "Passing"),
                .init(id: 13, name: "Passing"),
                .init(id: 14, name: "Passing"),
                .init(id: 15, name: "Passing"),
                .init(id: 16, name: "Passing"),
                .init(id: 17, name: "Passing"),
                .init(id: 18, name: "Passing")
            ])
        }
//        forceUpdate ? loadDrills() : cachedDrills()
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
