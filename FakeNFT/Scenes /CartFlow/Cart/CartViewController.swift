//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 25.03.2025.
//

import UIKit


protocol CartVCProtocol: UIViewController {
    init(presenter: CartPresenterProtocol)
    var presenter: CartPresenterProtocol { get set }
    
    func updateUI(price: Float, amount: Int)
    func endRefreshing()
    func changeCartState(_ state: CartState)
}


final class CartViewController: UIViewController, CartVCProtocol {
    
    // MARK: - Init
    
    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.viewController = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(resource: .cartSortButton), target: self, action: #selector(didTapSortButton))
        button.tintColor = .label
        return button
    }()
    
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
        label.text = NSLocalizedString("Cart.empty", comment: "")
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle(NSLocalizedString("ProceedToPayment", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private lazy var totalNftsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
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
    
    var presenter: CartPresenterProtocol
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        presenter.fetchOrder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.fetchOrder()
    }
    
    // MARK: protocol methods
    
    func changeCartState(_ state: CartState) {
        switch state {
        case .cartEmpty:
            cartTableView.isHidden = false
            backgroundView.isHidden = true
            navigationItem.rightBarButtonItem?.customView?.isHidden = true
            placeholderLabel.isHidden = false
        case .cartNonEmpty:
            cartTableView.isHidden = false
            backgroundView.isHidden = false
            navigationItem.rightBarButtonItem?.customView?.isHidden = false
            placeholderLabel.isHidden = true
        }
    }
    
    func updateUI(price: Float, amount: Int) {
        cartTableView.reloadData()
        totalNftsLabel.text = "\(amount) NFT"
        totalNftsPriceLabel.text = "\(price) ETH"
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
        
    // MARK: private methods
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        
        refreshControl.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        cartTableView.refreshControl = refreshControl
        
        view.addSubviews(cartTableView, backgroundView, placeholderLabel)
        backgroundView.addSubviews(labelsStackView, payButton)
        
        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
            payButton.widthAnchor.constraint(equalToConstant: 240),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.subviews.forEach { $0.isHidden = true }
        navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    
    // MARK: - OBJ-C methods
    
    @objc private func didPullRefresh() {
        presenter.fetchOrder()
    }
    
    @objc private func didTapPayButton() {
        let presenter = PaymentPresenter(servicesAssembly: presenter.servicesAssembly)
        let paymentVC = PaymentViewController(presenter: presenter)
        paymentVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    @objc private func didTapSortButton() {
        let actionSheet = UIAlertController(
            title: NSLocalizedString("Sort", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let byPrice = UIAlertAction(title: NSLocalizedString("Sort.price", comment: ""), style: .default) {[weak self] _ in
            guard let self else { return }
            presenter.sortCart(with: .byPrice)
        }
        let byRating = UIAlertAction(title: NSLocalizedString("Sort.rating", comment: ""), style: .default) {[weak self] _ in
            guard let self else { return }
            presenter.sortCart(with: .byRating)
        }
        let byName = UIAlertAction(title: NSLocalizedString("Sort.name", comment: ""), style: .default) {[weak self] _ in
            guard let self else { return }
            presenter.sortCart(with: .byName)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .cancel) { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
        
        let options = [byPrice, byRating, byName, cancel]
        
        options.forEach { actionSheet.addAction($0)}
        
        present(actionSheet, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CartTableViewCell
        else { return UITableViewCell() }
        
        let nft = presenter.nfts[indexPath.row]
        let action = { [weak self] in
            guard let self else { return }
            
            let deletetionVC = DeletionViewController(image: nft.images[1], action: { self.presenter.deleteNft(id: nft.id) } )
            deletetionVC.modalPresentationStyle = .overFullScreen
            self.present(deletetionVC, animated: false)
        }
        
        cell.configureCell(nft: nft, action: action)
        cell.backgroundColor = .clear
        return cell
    } 
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

