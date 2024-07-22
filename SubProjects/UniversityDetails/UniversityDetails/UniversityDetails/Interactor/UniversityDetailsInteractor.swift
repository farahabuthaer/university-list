//
//  UniversityDetailsInteractor.swift
//  university-listing
//
//  Created by fabuthaher001 on 21/07/2024.
//

import Foundation

// as the module is purely UI and using the data from the previous page, this is not being used, but added for the sake of VIPER architecture and for future use if the app were to expand

public protocol UniversityDetailInteractorProtocol {
    var presenter: UniversityDetailPresenterProtocol? { get set }
}

public class UniversityDetailInteractor: UniversityDetailInteractorProtocol {
    public var presenter: UniversityDetailPresenterProtocol?
    
}

