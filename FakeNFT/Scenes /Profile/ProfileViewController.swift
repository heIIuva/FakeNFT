//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 25.03.2025.
//

import UIKit


final class ProfileViewController: UIViewController, ProfileView {

    let servicesAssembly: ServicesAssembly
    
    private lazy var presenter: ProfilePresenter = {
        ProfilePresenter(view: self, profileService: servicesAssembly.profileService)
    }()

    private lazy var profileCardView: ProfileCardView = {
        let profileCardView = ProfileCardView()
        profileCardView.translatesAutoresizingMaskIntoConstraints = false
        return profileCardView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()

    private let items = [
        ("Мои NFT", 112),
        ("Избранные NFT", 11),
        ("О разработчике", nil)
    ]

    // MARK: - Init
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar()
        setupView()
        presenter.viewDidLoad()
    }

    // MARK: - Setup
    private func setupView() {
        [profileCardView, tableView].forEach(view.addSubview)

        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: ProfileLayoutConstants.profileCardTop),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: profileCardView.bottomAnchor,
                                           constant: ProfileLayoutConstants.tableViewTop),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(items.count) * ProfileLayoutConstants.rowHeight)
        ])
    }

    private func setupNavigationBar() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.tintColor = .iconPrimary
        button.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK: - ProfileView
    func display(profile: Profile) {
        profileCardView.configure(with: profile)
    }
    
    func showEditProfile(with profile: Profile) {
        let editProfileViewController = EditProfileViewController(profile: profile)
        let nav = UINavigationController(rootViewController: editProfileViewController)
        nav.setNavigationBarHidden(true, animated: false)
        present(nav, animated: true)
    }

    //MARK: - Actions
    @objc private func editButtonTapped() {
        presenter.editButtonTapped()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ProfileLayoutConstants.rowHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let (title, count) = items[indexPath.row]

        let text = count != nil ? "\(title) (\(count!))" : title

        cell.textLabel?.text = text
        cell.textLabel?.textColor = .textPrimary
        cell.textLabel?.font = .bodyBold
        cell.backgroundColor = .background
        cell.selectionStyle = .none
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .iconPrimary
        cell.accessoryView = chevron
        return cell
    }
}


