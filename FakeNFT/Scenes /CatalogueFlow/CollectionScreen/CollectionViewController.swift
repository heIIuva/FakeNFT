//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(resource: .navBackButton).withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        return backButton
    } ()
    
    private lazy var collectionCoverImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .mockCollection))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    } ()
    
    private lazy var collectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.text = "Peach"
        return label
    } ()
    
    private lazy var collectionAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.text = "Автор коллекции:"
        return label
    } ()
    
    private lazy var collectionAuthorLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("John Doe", for: .normal)
        button.setTitleColor(UIColor(resource: .nftBlueUniversal), for: .normal)
        button.titleLabel?.font = UIFont.caption1
        return button
    } ()
    
    private lazy var collectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.numberOfLines = 0
        label.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        return label
    } ()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(NftCollectionViewCell.self)
        collectionView.contentInset = .init(top: 24, left: 16, bottom: 34, right: 16)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        return collectionView
    } ()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    } ()
    
    // MARK: - Methods of lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .nftWhite)
        setupUI()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        [scrollView, backButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        scrollView.constraintEdges(to: view)
        setupScrollView()
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
        ])
    }
         
    private func setupScrollView() {
        [collectionCoverImageView,
         collectionTitleLabel,
         collectionAuthorLabel,
         collectionAuthorLinkButton,
         collectionDescriptionLabel,
         collectionView].forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            collectionCoverImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionCoverImageView.heightAnchor.constraint(equalToConstant: 310),
            collectionCoverImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            collectionCoverImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionCoverImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            collectionTitleLabel.topAnchor.constraint(equalTo: collectionCoverImageView.bottomAnchor, constant: 16),
            collectionTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collectionTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            collectionTitleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            collectionAuthorLabel.topAnchor.constraint(equalTo: collectionTitleLabel.bottomAnchor, constant: 8),
            collectionAuthorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collectionAuthorLabel.heightAnchor.constraint(equalToConstant: 28),
            
            collectionAuthorLinkButton.leadingAnchor.constraint(equalTo: collectionAuthorLabel.trailingAnchor, constant: 4),
            collectionAuthorLinkButton.centerYAnchor.constraint(equalTo: collectionAuthorLabel.centerYAnchor),
            
            collectionDescriptionLabel.topAnchor.constraint(equalTo: collectionAuthorLabel.bottomAnchor),
            collectionDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collectionDescriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: collectionDescriptionLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func handleBackButtonTap() {
        dismiss(animated: true)
    }
    
    @objc private func handleAuthorButtonTap() {
        // TODO: WebView implementation
    }
}

// MARK: - Extensions

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NftCollectionViewCell.defaultReuseIdentifier,
            for: indexPath) as? NftCollectionViewCell
        else { return UICollectionViewCell() }
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
