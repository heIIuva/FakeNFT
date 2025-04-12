//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Денис Максимов on 11.04.2025.
//

import Foundation

struct ProfileGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var dto: Encodable?
}
