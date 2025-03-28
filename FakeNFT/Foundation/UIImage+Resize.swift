//
//  UIImage+Resize.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import UIKit

extension UIImage {
    
    func resized(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let format = UIGraphicsImageRenderer(size: CGSize(width: newWidth, height: newHeight))
        return format.image { context in
            self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        }
    }
}
