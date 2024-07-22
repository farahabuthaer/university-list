//
//  UniversityDetailsPresenter.swift
//  university-listing
//
//  Created by fabuthaher001 on 21/07/2024.
//

import Foundation

public protocol UniversityDetailPresenterProtocol {
    var router: UniversityDetailRouterProtocol? { get set }
    var interactor: UniversityDetailInteractorProtocol? { get set }
    var view: UniversityDetailViewProtocol? { get set }
    func handleRefreshAction(_ action: (() -> Void)?)

}

public class UniversityDetailPresenter: UniversityDetailPresenterProtocol {
    
    public var router: UniversityDetailRouterProtocol?
    
    public var interactor: UniversityDetailInteractorProtocol?
    
    public var view: UniversityDetailViewProtocol?
    
    public func handleRefreshAction(_ action: (() -> Void)?) {
        action?() ?? {}()
        router?.popViewController()
    }
}

