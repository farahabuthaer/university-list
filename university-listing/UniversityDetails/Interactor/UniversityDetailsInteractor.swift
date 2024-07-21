//
//  UniversityDetailsInteractor.swift
//  university-listing
//
//  Created by fabuthaher001 on 21/07/2024.
//

import Foundation
import RealmSwift

// as the module is purely UI and using the data from the previous page, this is not being used, but added for the sake of VIPER architecture and for future use if the app were to expand

protocol UniversityDetailInteractorProtocol {
    var presenter: UniversityDetailPresenterProtocol? { get set }
}

class UniversityDetailInteractor: UniversityDetailInteractorProtocol {
    var presenter: UniversityDetailPresenterProtocol?
    
}

