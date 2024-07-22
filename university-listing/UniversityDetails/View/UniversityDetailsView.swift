//
//  UniversityDetailsView.swift
//  university-listing
//
//  Created by fabuthaher001 on 19/07/2024.
//

import Foundation
import UIKit

public protocol UniversityDetailViewProtocol {
    var presenter: UniversityDetailPresenterProtocol? { get set }
    var refreshUniversitiesAction: (() -> Void)?  { get set }
    var university: UniversityEntity?  { get set }
}

public class UniversityDetailViewController: UIViewController, UniversityDetailViewProtocol {
    
    public var presenter: (any UniversityDetailPresenterProtocol)?
    
    public var refreshUniversitiesAction: (() -> Void)?

    public var university: UniversityEntity? {
        didSet {
            configureView()
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let webLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.blue, for: .normal)
//        button.addTarget(UniversityDetailViewController.self, action: #selector(openWebLink), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDetails))
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = refreshButton
        
        view.addSubview(nameLabel)
        view.addSubview(stateLabel)
        view.addSubview(countryLabel)
        view.addSubview(codeLabel)
        view.addSubview(webLinkButton)
        
        configureView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameLabel.frame = CGRect(x: 20, y: 100, width: view.frame.size.width - 40, height: 60)
        
        stateLabel.frame = CGRect(x: 20, y: nameLabel.frame.maxY + 10, width: view.frame.size.width - 40, height: 40)
        countryLabel.frame = CGRect(x: 20, y: stateLabel.frame.maxY + 10, width: view.frame.size.width - 120, height: 30)
        codeLabel.frame = CGRect(x: countryLabel.frame.maxX + 30, y: stateLabel.frame.maxY + 10, width: view.frame.size.width - 80, height: 30)
        
        webLinkButton.frame = CGRect(x: 20, y: countryLabel.frame.maxY + 10, width: view.frame.size.width - 40, height: 40)
    }
    
    private func configureView() {
        guard let university = university else { return }
        nameLabel.text = university.name
        if (university.stateProvince != nil)
        {
            stateLabel.text = university.stateProvince
        } else {
            stateLabel.text = "UAE State"
        }
        countryLabel.text = university.country
        codeLabel.text = university.alphaTwoCode
        webLinkButton.setTitle(university.webPages.first, for: .normal)
    }
    
    @objc private func openWebLink() {
        guard let urlString = university?.webPages.first, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func refreshDetails() {
        presenter?.handleRefreshAction(refreshUniversitiesAction)
    }
}
