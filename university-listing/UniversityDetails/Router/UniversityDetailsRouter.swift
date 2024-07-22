//
//  UniversityDetailsRouter.swift
//  university-listing
//
//  Created by fabuthaher001 on 21/07/2024.
//

import Foundation
import UIKit

public typealias EntryPointDetails = UniversityDetailViewProtocol & UIViewController

public protocol UniversityDetailRouterProtocol {
    var entry: EntryPointDetails? { get }
    
    static func start() -> UniversityDetailRouterProtocol
    func popViewController()
}

public class UniversityDetailRouter: UniversityDetailRouterProtocol {
    
    public var entry: EntryPointDetails?
    
    public static func start() -> UniversityDetailRouterProtocol {
        let router = UniversityDetailRouter()
        
        // add VIP
        var view: UniversityDetailViewProtocol = UniversityDetailViewController()
        var interactor: UniversityDetailInteractorProtocol = UniversityDetailInteractor()
        var presenter: UniversityDetailPresenterProtocol = UniversityDetailPresenter()
        
        // refrenceing VIPER
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPointDetails
        
        return router
    }
    
    public func popViewController() {
        entry?.navigationController?.popViewController(animated: true)
    }
}
