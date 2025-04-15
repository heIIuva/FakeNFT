//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 06.04.2025.
//

import UIKit
import ProgressHUD


protocol PaymentVCProtocol: UIViewController {
    init(presenter: PaymentPresenterProtocol)
    var presenter: PaymentPresenterProtocol { get set }
    
    func onPaymentConfirmationResult(message: String, _ result: PaymentConfirmationResult)
}


final class PaymentViewController: UIViewController, PaymentVCProtocol {
    
    //MARK: - Init
    
    init(presenter: PaymentPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.viewController = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private lazy var currencyCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(CurrencyCell.self, forCellWithReuseIdentifier: reuseID)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    private lazy var backButton: UIButton = {
        guard let image = UIImage(systemName: "chevron.left") else { return UIButton() }
        let button = UIButton.systemButton(
            with: image,
            target: self,
            action: #selector(popVC)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
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
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle(Localizable.purchase, for: .normal)
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localizable.termsTitle
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var termsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(didTapTermsButton),
            for: .touchUpInside
        )
        button.setTitleColor(.link, for: .normal)
        button.setTitle(Localizable.termsButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        return button
    }()
    
    private lazy var termsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [termsLabel, termsButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 0
        return stack
    }()
    
    private let reuseID = CurrencyCell.reuseIdentifier
    
    var presenter: PaymentPresenterProtocol
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        presenter.fetchCurrencies() { [weak self] in
            guard let self else { return }
            self.currencyCollection.reloadData()
        }
    }
    
    // MARK: - protocol methods
    
    func onPaymentConfirmationResult(message: String, _ result: PaymentConfirmationResult) {
        switch result {
        case .successful:
            let viewController = PaymentConfirmationViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case .failure:
            onUnsuccessfulPayment(message: message)
        }
    }
        
    // MARK: - private methods
    
    private func setupUI() {
        title = Localizable.paymentTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.backgroundColor = .systemBackground
        
        view.addSubviews(currencyCollection, backgroundView, payButton, termsStack)
        
        NSLayoutConstraint.activate([
            currencyCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currencyCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencyCollection.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            currencyCollection.heightAnchor.constraint(greaterThanOrEqualToConstant: 250),
            
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 200),
            
            termsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            termsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            termsStack.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16),
            
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func onUnsuccessfulPayment(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString(message, comment: ""),
            message: nil,
            preferredStyle: .alert
        )
        
        let repeatPayment = UIAlertAction(title: Localizable.errorRepeat, style: .default) {[weak self] _ in
            guard let self else { return }
            presenter.confirmPayment()
        }
        let cancel = UIAlertAction(title: Localizable.cancel, style: .cancel) {[weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
        
        let actions = [cancel, repeatPayment]
        
        actions.forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - OBJ-C methods
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func didTapPayButton() {
        presenter.confirmPayment()
    }
    
    @objc private func didTapTermsButton() {
        present(TermsWebViewController(), animated: true)
    }
}

// MARK: collection data source

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? CurrencyCell
        else { return UICollectionViewCell() }
        
        let currency = presenter.currencies[indexPath.row]
        cell.configureCell(currency: currency)
        cell.setSelected(presenter.selectedCurrencyIndex == indexPath)

        return cell
    }
}
// MARK: collection delegate
extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectedCurrencyIndex = indexPath
        presenter.selectedCurrency = presenter.currencies[indexPath.row]
        collectionView.reloadData()
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 178, height: 46)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
}
