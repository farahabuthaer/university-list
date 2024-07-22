import UIKit

public protocol UniversityDetailViewProtocol {
    var presenter: UniversityDetailPresenterProtocol? { get set }
    var refreshUniversitiesAction: (() -> Void)? { get set }
    var university: UniversityEntity? { get set }
}

class UniversityDetailViewController: UIViewController, UniversityDetailViewProtocol {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var webLinkButton: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    
    public var presenter: UniversityDetailPresenterProtocol?
    public var refreshUniversitiesAction: (() -> Void)?

    public var university: UniversityEntity? {
        didSet {
            if isViewLoaded {
                configureView()
            }
        }
    }

    private lazy var refreshButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDetails))
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = refreshButton
        configureView()
    }

    private func configureView() {
        guard let university = university else { return }
        nameLabel.text = university.name
        stateLabel.text = university.stateProvince ?? "UAE State"
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

