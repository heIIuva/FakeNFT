//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 04.04.2025.
//

import UIKit

final class MyNftViewController: UIViewController, MyNftView {
    
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Properties

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var nftItems: [Nft] = []

    private lazy var presenter: MyNftPresenter = {
        MyNftPresenter(view: self)
    }()
    
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
        view.backgroundColor = .systemBackground
        navigationItem.title = "Мои NFT"

        setupTableView()
        setupBackButton()
        presenter.viewDidLoad()
    }

    // MARK: - MyNFTView

    func display(nfts: [Nft]) {
        self.nftItems = nfts
        tableView.reloadData()
    }

    // MARK: - UI Setup

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NftTableViewCell.self, forCellReuseIdentifier: NftTableViewCell.identifier)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupBackButton() {
        guard let backImage = UIImage(named: "backward") else { return }
        let backButton = UIBarButtonItem(image: backImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        if navigationController?.viewControllers.first == self {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nftItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NftTableViewCell.identifier, for: indexPath) as? NftTableViewCell else {
            return UITableViewCell()
        }

        let nft = nftItems[indexPath.row]
        cell.configure(with: nft)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
