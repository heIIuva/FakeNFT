//
//  UIView+parentViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 03.04.2025.
//
import UIKit

extension UIView {
    func parentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let current = responder {
            if let vc = current as? UIViewController {
                return vc
            }
            responder = current.next
        }
        return nil
    }
}
