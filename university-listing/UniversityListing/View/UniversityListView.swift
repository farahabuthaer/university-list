//
//  View.swift
//  university-listing
//
//  Created by fabuthaher001 on 18/07/2024.
//

// reference presenter

import Foundation
import UIKit

protocol UniversityListViewProtocol {
    var presenter: UniversityListPresenterProtocol? { get set }
    
    func update(with universities: [University])
    func update(with error: String)
}

class UniversityViewController: UIViewController, UniversityListViewProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: (any UniversityListPresenterProtocol)?
    var universities: [University] = []
    
    // table for listing the universities
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UniversityCell")
        table.isHidden = true
        return table
    }()
    
    // show error message when API fails and no local Data is cached
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    view.addSubview(errorLabel)
        
    errorLabel.center = view.center
    tableView.dataSource = self
    tableView.delegate = self
    tableView.isHidden = false
    errorLabel.isHidden = true
}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    // update to show the data
    func update(with universities: Universities) {
        self.universities = universities
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    // update to show the error message
    func update(with error: String) {
        self.universities = []
        DispatchQueue.main.async {
            self.tableView.isHidden = true
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UniversityCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let university = universities[indexPath.row]
        cell?.textLabel?.text = university.name
        cell?.textLabel?.numberOfLines = 0 
        cell?.textLabel?.lineBreakMode = .byWordWrapping 
        cell?.detailTextLabel?.text = university.stateProvince
        
        return cell!
    }
    
    // for when a university is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUniversity = universities[indexPath.row]
        presenter?.navigateToUniversityDetail(university: selectedUniversity)
    }
}


