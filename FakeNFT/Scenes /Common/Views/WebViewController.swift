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

        webView.navigationDelegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        webView.backgroundColor

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

    private var backgroundHex: String {
        traitCollection.userInterfaceStyle == .dark ? "#1A1B22" : "#FFFFFF"
    }

    private var textHex: String {
        traitCollection.userInterfaceStyle == .dark ? "#FFFFFF" : "#1A1B22"
    }

    private func injectThemeIntoWebView() {
        let js = """
        document.querySelectorAll('*').forEach((element) => {
            element.style.backgroundColor = '\(backgroundHex)';
            element.style.color = '\(textHex)';

            if (element.tagName === 'SVG' || element.querySelector('svg')) {
                element.style.fill = '\(textHex)';
                element.style.stroke = '\(textHex)';
            }

            if (element.tagName === 'BUTTON' || element.tagName === 'INPUT' || element.style.borderColor) {
                element.style.borderColor = '\(textHex)';
            }

            if (element.tagName === 'A') {
                element.style.color = '\(textHex)';
                element.style.textDecoration = 'none';
            }

            if (element.tagName === 'INPUT' && (element.type === 'checkbox' || element.type === 'radio')) {
                element.style.accentColor = '\(textHex)';
            }

            if (element.tagName === 'SELECT') {
                element.style.backgroundColor = '\(backgroundHex)';
                element.style.color = '\(textHex)';
                element.style.borderColor = '\(textHex)';
            }

            if (element.tagName === 'TEXTAREA') {
                element.style.backgroundColor = '\(backgroundHex)';
                element.style.color = '\(textHex)';
                element.style.borderColor = '\(textHex)';
            }
        });
        """

        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            injectThemeIntoWebView()
        }
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIBlockingProgressHUD.show()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIBlockingProgressHUD.dismiss()
        injectThemeIntoWebView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIBlockingProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIBlockingProgressHUD.dismiss()
    }
}
