//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 25.03.2025.
//

import UIKit


final class CartViewController: UIViewController {
    
    // MARK: - Init
    
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private lazy var cartTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CartTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        table.allowsSelection = false
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = NSLocalizedString("Cart is empty", comment: "")
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .label
        button.setTitle(NSLocalizedString("Proceed to payment", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.titleLabel?.textColor = .systemBackground
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private lazy var totalNftsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var totalNftsPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(resource: .nftGreen)
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [totalNftsLabel, totalNftsPriceLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor(resource: .nftLightGray)
        return view
    }()
    
    private let cellReuseIdentifier = CartTableViewCell.reuseIdentifier
    private var nfts: [Nft] = [
        Nft(name: "nigga", id: "1", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/1.png")!], rating: 2, price: 1.78),
        Nft(name: "nigga", id: "1", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/1.png")!], rating: 2, price: 1.78)
    ] {
        didSet {
            
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: private methods
    
    private func setupNavigationBar() {
        let sortButton = UIBarButtonItem(
            image: UIImage(resource: .cartSortButton),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        sortButton.tintColor = .label
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupUI() {
        view.addSubviews(cartTableView, backgroundView)
        backgroundView.addSubviews(labelsStackView, payButton)
        
        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            cartTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 76),
            
            labelsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            
            payButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            payButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            payButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func calculateCart() {
        
    }
    
    private func cartIsEmpty() {
        cartTableView.removeFromSuperview()
        navigationItem.rightBarButtonItem?.customView?.removeFromSuperview()

        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func cartNonEmpty() {
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - OBJ-C methods
    
    @objc private func payButtonTapped() {}
    
    @objc private func sortButtonTapped() {}
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !nfts.isEmpty else {
            cartIsEmpty()
            return 0
        }
        cartNonEmpty()
        return nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CartTableViewCell
        let nft = nfts[indexPath.row]
        cell.configureCell(nft: nft)
        cell.backgroundColor = .clear
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

