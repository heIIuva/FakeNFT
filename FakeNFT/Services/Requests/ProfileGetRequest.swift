//
//  ProfileGetRequest.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 29.03.2025.
//

import Foundation

struct ProfileGetRequest: NetworkRequest {
    let profileId: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
    }

    var httpMethod: HttpMethod = .get
    var dto: Dto? = nil
}
