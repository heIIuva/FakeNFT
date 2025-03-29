//
//  InsetTextField.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 29.03.2025.
//

import UIKit

final class InsetTextField: UITextField {

    private let textInset: UIEdgeInsets

    init(inset: UIEdgeInsets) {
        self.textInset = inset
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
}
