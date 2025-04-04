//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 25.03.2025.
//

import UIKit


final class ProfileViewController: UIViewController, ProfileView {
    
    private let servicesAssembly: ServicesAssembly
    
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
    
    private var items: [(String, Int?)]  =
        [
            ("Мои NFT", nil),
            ("Избранные NFT", nil),
            ("О разработчике", nil)
        ]
    
    // MARK: - Init
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        
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
        items = [
            ("Мои NFT", profile.nfts.count),
            ("Избранные NFT", profile.likes.count),
            ("О разработчике", nil)
        ]

        tableView.reloadData()
    }
    
    func showEditProfile(with profile: Profile) {
        let editProfileViewController = EditProfileViewController(presenter: presenter, profile: profile)
        let nav = UINavigationController(rootViewController: editProfileViewController)
        nav.setNavigationBarHidden(true, animated: false)
        nav.presentationController?.delegate = editProfileViewController 
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
        ?? UITableViewCell(style: .value1, reuseIdentifier: "ProfileCell")
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedItem = items[indexPath.row].0

        switch selectedItem {
        case "Мои NFT":
            let nftViewController = MyNftViewController(servicesAssembly: servicesAssembly)
            let nav = UINavigationController(rootViewController: nftViewController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        default:
            break
        }
    }
    
}


