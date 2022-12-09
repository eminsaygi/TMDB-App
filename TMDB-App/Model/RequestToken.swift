//
//  Authentication.swift
//  TMDB-App
//
//  Created by Emin Saygı on 30.11.2022.
//

import Foundation

struct RequestToken: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
