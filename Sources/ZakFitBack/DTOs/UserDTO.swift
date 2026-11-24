//
//  UserDTO.swift
//  ZakFitBack
//
//  Created by Leskeu  on 24/11/2026.
//

import Foundation
import Vapor

struct AuthDTO: Content {
    let token: String
}

struct CreateUserDTO: Content {
    let lastname: String
    let firstname: String
    let email: String
    let password: String
}

struct LoginRequestDTO: Content {
    let email: String
    let password: String
}

struct UserResponseDTO: Content {
    let id: Int?
    let lastname: String
    let firstname: String
    let email: String
    let createdAt: Date

    init(user: User) {
        self.id = user.id
        self.lastname = user.lastname
        self.firstname = user.firstname
        self.email = user.email
        self.createdAt = user.createdAt
    }
}

