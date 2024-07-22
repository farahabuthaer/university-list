//
//  Router.swift
//  university-listing
//
//  Created by fabuthaher001 on 18/07/2024.
//

import Foundation
import UIKit
import UniversityDetails
typealias EntryPoint = UniversityListViewProtocol & UIViewController

protocol UniversityListRouterProtocol {
    var entry: EntryPoint? { get }
    
    static func start() -> UniversityListRouterProtocol
    func navigateToUniversityDetail(university: University, refreshAction: @escaping () -> Void)
}

class UniversityRouter: UniversityListRouterProtocol {
    
    var entry: EntryPoint?
    
    static func start() -> UniversityListRouterProtocol {
        let router = UniversityRouter()
        
        // add VIP
        var view: UniversityListViewProtocol = UniversityListViewController()
        var interactor: UniversityListInteractorProtocol = UniversityInteractor()
        var presenter: UniversityListPresenterProtocol = UniversityPresenter()
        
        // refrenceing VIPER
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        
        return router
    }
    
    func navigateToUniversityDetail(university: University, refreshAction: @escaping () -> Void)
 {
        let universityDetailsRouter = UniversityDetailRouter.start()
        var universityDetailVC = universityDetailsRouter.entry
     universityDetailVC?.university = UniversityEntity(webPages: university.webPages, country: university.country, stateProvince: university.stateProvince, domains: university.domains, alphaTwoCode: university.alphaTwoCode, name: university.name)
        universityDetailVC?.refreshUniversitiesAction = refreshAction
     entry?.navigationController?.pushViewController(universityDetailVC!, animated: true)
    }
    
}

