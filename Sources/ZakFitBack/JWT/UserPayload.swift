//
//  UserPayload.swift
//  ZakFitBack
//
//  Created by Leskeu  on 24/11/2026.
//

import Foundation
import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    var id: Int
    var expiration: Date

    init(id: Int) {
        self.id = id
        self.expiration = Date().addingTimeInterval(3600 * 24)
    }

    func verify(using signer: JWTSigner) throws {
        if expiration < Date() {
            throw JWTError.invalidJWK
        }
    }
}
