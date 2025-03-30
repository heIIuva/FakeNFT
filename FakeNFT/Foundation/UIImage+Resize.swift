//
//  UIImage+Resize.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import UIKit

extension UIImage {
    
    func resized(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        let format = UIGraphicsImageRenderer(size: CGSize(width: newWidth, height: newHeight))
        return format.image { _ in
            draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        }
    }
}
