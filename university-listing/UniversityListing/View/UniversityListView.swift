//
//  MotasemScreenViewController.swift
//  university-listing
//
//  Created by fabuthaher001 on 22/07/2024.
//

import UIKit

protocol UniversityListViewProtocol {
    var presenter: UniversityListPresenterProtocol? { get set }
    
    func update(with universities: [University])
    func update(with error: String)
}

class UniversityListViewController: UIViewController, UniversityListViewProtocol, UITableViewDelegate, UITableViewDataSource {
    
    
    var presenter: (any UniversityListPresenterProtocol)?
    var universities: [University] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UniversityCell")
        tableView.isHidden = false
        errorLabel.isHidden = true
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
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUniversity = universities[indexPath.row]
        presenter?.navigateToUniversityDetail(university: selectedUniversity)
    }
    
    func update(with universities: [University]) {
        self.universities = universities
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.errorLabel.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    func update(with error: String) {
        self.universities = []
        DispatchQueue.main.async {
            self.tableView.isHidden = true
            self.errorLabel.text = error
            self.errorLabel.isHidden = false
        }
    }
}
