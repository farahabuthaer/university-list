//
//  Presenter.swift
//  university-listing
//
//  Created by fabuthaher001 on 18/07/2024.
//

// ref to interacter, router and view

import Foundation
import UIKit

enum FetchError: Error {
    case invalidURL
    case requestFailed
    case invalidData
}

protocol UniversityListPresenterProtocol {
    var router: UniversityListRouterProtocol? { get set }
    var interactor: UniversityListInteractorProtocol? { get set }
    var view: UniversityListViewProtocol? { get set }
    
    func InteractorDidFetchUniversities(with result: Result<Universities, Error>)
    func refreshUniversities()
    func navigateToUniversityDetail(university: University)
}

class UniversityPresenter: UniversityListPresenterProtocol {
    
    var router: UniversityListRouterProtocol?
    
    var interactor: UniversityListInteractorProtocol? {
        didSet {
            interactor?.fetchUniversities()
        }
    }
    
    
    var view: UniversityListViewProtocol?
    
    func InteractorDidFetchUniversities(with result: Result<Universities, Error>) {
        switch result {
            case .success(let universities):
                view?.update(with: universities)
            case .failure(_):
                view?.update(with: "Something went wrong")
        }
    }
    
    func refreshUniversities() {
        print("refreshing universitiesss")
        interactor?.fetchUniversities()
    }
    
    func navigateToUniversityDetail(university: University) {
        router?.navigateToUniversityDetail(university: university, refreshAction: refreshUniversities)
    }
}

