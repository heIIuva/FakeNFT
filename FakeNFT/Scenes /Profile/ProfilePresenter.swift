//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 27.03.2025.
//
import Foundation


protocol ProfileView: AnyObject {
    func display(profile: Profile)
}

final class ProfilePresenter {
    weak var view: ProfileView?
    private let profileService: ProfileService

    init(view: ProfileView, profileService: ProfileService) {
        self.view = view
        self.profileService = profileService
    }

    func viewDidLoad() {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success(let profile):
                    self?.view?.display(profile: profile)
                case .failure(let error):
                    print("Failed to fetch profile:", error)
                }
            }
        }
    }
}
