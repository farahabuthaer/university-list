//
//  UniversityEntity.swift
//  UniversityDetails
//
//  Created by fabuthaher001 on 22/07/2024.
//

import Foundation
public struct UniversityEntity {
    let webPages: [String]
    let country: String
    let stateProvince: String?
    let domains: [String]
    let alphaTwoCode: String
    let name: String
    
    public init(webPages: [String], country: String, stateProvince: String?, domains: [String], alphaTwoCode: String, name: String) {
        self.webPages = webPages
        self.country = country
        self.stateProvince = stateProvince
        self.domains = domains
        self.alphaTwoCode = alphaTwoCode
        self.name = name
    }
}
