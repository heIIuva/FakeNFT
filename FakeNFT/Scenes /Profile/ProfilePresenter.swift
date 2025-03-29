//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 27.03.2025.
//
import Foundation


protocol ProfileView: AnyObject {
    func display(profile: Profile)
    func showEditProfile(with profile: Profile)
}

final class ProfilePresenter {
    weak var view: ProfileView?
    private let profileService: ProfileService
    private var profile: Profile?

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
                    self?.profile = profile
                    self?.view?.display(profile: profile)

                case .failure(let error):
                    print("Failed to fetch profile:", error)
                }
            }
        }
    }
    
    func editButtonTapped() {
        guard let profile = profile else { return }
        view?.showEditProfile(with: profile)
    }
}
