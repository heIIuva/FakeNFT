//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 08.04.2025.
//

import UIKit
import ProgressHUD


final class UIBlockingProgressHUD {

    //MARK: - Properties
    
    private static var window: UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first
    }
    
    private let hud = ProgressHUD()
    
    //MARK: - Methods
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
