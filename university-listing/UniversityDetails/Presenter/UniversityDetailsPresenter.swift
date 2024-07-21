//
//  UniversityDetailsPresenter.swift
//  university-listing
//
//  Created by fabuthaher001 on 21/07/2024.
//

import Foundation

protocol UniversityDetailPresenterProtocol {
    var router: UniversityDetailRouterProtocol? { get set }
    var interactor: UniversityDetailInteractorProtocol? { get set }
    var view: UniversityDetailViewProtocol? { get set }
    func handleRefreshAction(_ action: (() -> Void)?)

}

class UniversityDetailPresenter: UniversityDetailPresenterProtocol {
    
    var router: UniversityDetailRouterProtocol?
    
    var interactor: UniversityDetailInteractorProtocol?
    
    var view: UniversityDetailViewProtocol?
    
    func handleRefreshAction(_ action: (() -> Void)?) {
        action?() ?? {
                    print("refreshUniversitiesAction is nil")
                }()
        router?.popViewController()
    }
}

