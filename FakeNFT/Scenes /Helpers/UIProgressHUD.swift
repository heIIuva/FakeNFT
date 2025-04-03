//
//  UIProgressHUD.swift
//  FakeNFT
//
//  Created by Денис Максимов on 03.04.2025.
//

import UIKit
import ProgressHUD

final class UIProgressHUD {
    
    //MARK: - Properties
    
    private static var window: UIWindow? {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first
    }
    
    //MARK: - Methods
    
    static func blockingShow() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.colorHUD = .clear
        ProgressHUD.colorBackground = .clear
        ProgressHUD.colorAnimation = UIColor(resource: .nftBlack)
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.show()
    }
    
    static func blockingDismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
    static func show() {
        ProgressHUD.show()
    }
    
    static func dismiss() {
        ProgressHUD.dismiss()
    }
}
