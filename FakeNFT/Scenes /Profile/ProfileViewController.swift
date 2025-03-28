//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 25.03.2025.
//

import UIKit

import UIKit

final class ProfileViewController: UIViewController {

    let servicesAssembly: ServicesAssembly

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

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBar()
        setupUI()
    }

    private func setupUI() {
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
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }

    @objc private func buttonTapped() {
        print("Button tapped")
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
