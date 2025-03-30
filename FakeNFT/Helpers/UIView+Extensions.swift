//
//  UIView+Extensions.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 30.03.2025.
//

import UIKit


extension UIView {
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
