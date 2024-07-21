//
//  Entity.swift
//  university-listing
//
//  Created by fabuthaher001 on 18/07/2024.
//

import Foundation
import RealmSwift

// MARK: - University
struct University: Codable {
    let webPages: [String]
    let country: String
    let stateProvince: String?
    let domains: [String]
    let alphaTwoCode: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case webPages = "web_pages"
        case country
        case stateProvince = "state-province"
        case domains
        case alphaTwoCode = "alpha_two_code"
        case name
    }
}

extension University {
    init(from realmUniversity: UniversityRealm) {
        self.name = realmUniversity.name
        self.country = realmUniversity.country
        self.stateProvince = realmUniversity.stateProvince
        self.alphaTwoCode = realmUniversity.alphaTwoCode
        self.webPages = Array(realmUniversity.webPages)
        self.domains = Array(realmUniversity.domains)
    }
}

typealias Universities = [University]

class UniversityRealm: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var stateProvince: String? = nil
    let webPages = List<String>()
    let domains = List<String>()
    @objc dynamic var alphaTwoCode: String = ""
    
    convenience init(from university: University) {
        self.init()
        self.name = university.name
        self.country = university.country
        self.stateProvince = university.stateProvince
        self.alphaTwoCode = university.alphaTwoCode
        university.webPages.forEach { self.webPages.append($0) }
        university.domains.forEach { self.domains.append($0) }
    }
    
    override static func primaryKey() -> String? {
        return "name" // Assuming 'name' is unique for each university
    }
}
