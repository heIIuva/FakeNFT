//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 28.03.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {

    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.colorHUD = .clear
        ProgressHUD.colorBackground = .clear
        ProgressHUD.colorAnimation = .progressHudColor
        ProgressHUD.show()
    }
    
    static func dismiss(){
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
