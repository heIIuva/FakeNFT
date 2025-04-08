//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 04.04.2025.
//

import UIKit

final class MyNftViewController: UIViewController, NftView {

    private let servicesAssembly: ServicesAssembly

    // MARK: - Properties

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let nftIDs: [String]

    private lazy var presenter: NftPresenter = {
        NftPresenter(
            view: self,
            services: servicesAssembly,
            nftIDs: nftIDs
        )
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет NFT"
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.font = .bodyBold
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    // MARK: - Init
    init(servicesAssembly: ServicesAssembly, nftIDs: [String]) {
        self.servicesAssembly = servicesAssembly
        self.nftIDs = nftIDs
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
        setupSortButton()
        setupEmptyLabel()

        if nftIDs.isEmpty {
            showEmptyLabel()
        } else {
            presenter.viewDidLoad()
        }
    }

    // MARK: - MyNFTView
    func reloadData() {
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

    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NftLayoutConstants.emptyLabelHorizontalInset),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -NftLayoutConstants.emptyLabelHorizontalInset)
        ])
    }

    private func showEmptyLabel() {
        emptyLabel.isHidden = false
        tableView.isHidden = true
        navigationItem.rightBarButtonItem = nil // скрываем sort
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

    private func setupSortButton() {
        guard let sortImage = UIImage(named: "sort") else { return }
        let sortButton = UIBarButtonItem(
            image: sortImage,
            style: .plain,
            target: self,
            action: #selector(showSortMenu)
        )
        sortButton.tintColor = .label
        navigationItem.rightBarButtonItem = sortButton
    }

    @objc private func backButtonTapped() {
        if navigationController?.viewControllers.first == self {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func showSortMenu() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "По имени", style: .default) { _ in
            self.presenter.sort(by: .name)
        })

        alert.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
            self.presenter.sort(by: .price)
        })

        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.presenter.sort(by: .rating)
        })

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NftTableViewCell.identifier, for: indexPath) as? NftTableViewCell else {
            return UITableViewCell()
        }

        let nft = presenter.item(at: indexPath.row)
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
