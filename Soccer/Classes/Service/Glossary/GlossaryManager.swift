//
//  GlossaryManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 01.03.2023.
//

import RxSwift

protocol GlossaryManagerProtocol {
    func obtainLevels(forceUpdate: Bool) -> Single<[SkillLevel]>
}

final class GlossaryManager {
    enum Constants {
        static let skillLevels = "glossary_manager_skill_levels_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: GlossaryManagerProtocol
extension GlossaryManager: GlossaryManagerProtocol {
    // TODO: remove mocks
    func obtainLevels(forceUpdate: Bool) -> Single<[SkillLevel]> {
        Single<[SkillLevel]>.create { event in
            let url = Bundle.main.url(forResource: "SkillLevels", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let result = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            let skillLevels = GetSkillLevelsResponse.map(from: result)
            event(.success(skillLevels))
            
            return Disposables.create()
        }
        
//        forceUpdate ? loadLevels() : cachedLevels()
    }
}

// MARK: Private
private extension GlossaryManager {
    func loadLevels() -> Single<[SkillLevel]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSkillLevelsRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetSkillLevelsResponse.map(from: $0) }
            .do(onSuccess: { levels in
                guard let data = try? JSONEncoder().encode(levels) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.skillLevels)
            })
    }
    
    func cachedLevels() -> Single<[SkillLevel]> {
        Single<[SkillLevel]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.skillLevels) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let levels = try? JSONDecoder().decode([SkillLevel].self, from: data)
            
            event(.success(levels ?? []))
            
            return Disposables.create()
        }
    }
}
