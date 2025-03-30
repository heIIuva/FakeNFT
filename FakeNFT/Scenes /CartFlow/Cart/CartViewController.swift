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
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CartTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        table.allowsSelection = false
        table.separatorStyle = .none
        return table
    }()
    
    private let cellReuseIdentifier = CartTableViewCell.reuseIdentifier
    private let nfts: [Nft] = [
        Nft(name: "nigga", id: "1", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/1.png")!], rating: 2, price: 1.78)
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: private methods
    
    private func setupUI() {
        view.addSubviews(cartTableView)
        
        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            cartTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CartTableViewCell
        let nft = nfts[indexPath.row]
        cell.configureCell(nft: nft)
        cell.backgroundColor = .clear
        return cell
    }
}

