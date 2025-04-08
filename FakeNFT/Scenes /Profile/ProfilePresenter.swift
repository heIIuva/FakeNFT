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

    init(view: ProfileView, services: ServicesAssembly) {
        self.view = view
        self.profileService = services.profileService
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

    func updateProfile(
        name: String? = nil,
        avatar: String? = nil,
        description: String? = nil,
        website: String? = nil,
        likes: [String]? = nil,
        completion: ((Profile?) -> Void)? = nil
    ) {
        UIBlockingProgressHUD.show()

        profileService.updateProfile(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes
        ) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()

                switch result {
                case .success(let updatedProfile):
                    self?.profile = updatedProfile
                    self?.view?.display(profile: updatedProfile)
                case .failure(let error):
                    print("Failed to update profile:", error)
                }

                completion?(self?.profile)
            }
        }
    }
}
