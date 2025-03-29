//
//  UIViewController+KeyboardDismiss.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 29.03.2025.
//

import UIKit

extension UIViewController {
    func enableKeyboardDismissOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}
