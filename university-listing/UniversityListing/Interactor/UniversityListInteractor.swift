//
//  Interactor.swift
//  university-listing
//
//  Created by fabuthaher001 on 18/07/2024.
//

// ref to presentor

import Foundation
import RealmSwift

protocol UniversityListInteractorProtocol {
    var presenter: UniversityListPresenterProtocol? { get set }
    func fetchUniversities()
}

class UniversityInteractor: UniversityListInteractorProtocol {
    var presenter: UniversityListPresenterProtocol?
    private let networkService: NetworkServiceProtocol
    private let realm: Realm
    
    init(networkService: NetworkServiceProtocol = NetworkService(), realm: Realm = try! Realm()) {
        self.networkService = networkService
        self.realm = realm
    }
    
    func fetchUniversities() {
        guard let url = URL(string: "http://universities.hipolabs.com/search?country=United%20Arab%20Emirates") else {
            self.presenter?.InteractorDidFetchUniversities(with:.failure(FetchError.invalidURL))
            return
        }
        
        networkService.fetchData(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let universities = try JSONDecoder().decode([University].self, from: data)
                    self?.presenter?.InteractorDidFetchUniversities(with: .success(universities))
                    DispatchQueue.main.async {
                        self?.saveToLocalCache(universities)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.loadCachedUniversities()
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.loadCachedUniversities()
                }
            }
        }
    }
    
    private func saveToLocalCache(_ universities: [University]) {
        let realm = try! Realm()
        try! realm.write {
            universities.forEach { university in
                let realmUniversity = UniversityRealm(from: university)
                realm.add(realmUniversity, update: .modified)
            }
        }
    }
    
    private func loadCachedUniversities() {
        print("Loading cached universities")
        let realm = try! Realm()
        let realmUniversities = realm.objects(UniversityRealm.self)
        let universities = Array(realmUniversities.map { University(from: $0) })
        if universities.isEmpty {
            self.presenter?.InteractorDidFetchUniversities(with:.failure(FetchError.requestFailed))
        } else {
            print("Loaded \(universities.count) universities from cache")
            self.presenter?.InteractorDidFetchUniversities(with: .success(universities))
        }
    }
}




