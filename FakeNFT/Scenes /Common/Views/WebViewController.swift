//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 03.04.2025.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let webView: WKWebView
    private let url: URL

    init?(urlString: String) {
        guard let validURL = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return nil
        }

        self.url = validURL
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupView()
        setupBackButton()
        loadURL()
    }

    private func setupView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupBackButton() {
        guard let backImage = UIImage(named: "backward") else {
            return
        }

        let backButton = UIBarButtonItem(image: backImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .iconPrimary
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        if navigationController?.viewControllers.first == self {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func loadURL() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
