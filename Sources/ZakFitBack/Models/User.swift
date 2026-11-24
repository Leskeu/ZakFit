//
//  User.swift
//  ZakFitBack
//
//  Created by Leskeu  on 24/11/2026.
//
import Foundation
import Fluent

final class User: Model, @unchecked Sendable {

    static let schema = "users"

    @ID(custom: "id_user", generatedBy: .database)
    var id: Int?

    @Field(key: "lastname")
    var lastname: String

    @Field(key: "firstname")
    var firstname: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Field(key: "created_at")
    var createdAt: Date

    init() { }

    init(
        id: Int? = nil,
        lastname: String,
        firstname: String,
        email: String,
        passwordHash: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.lastname = lastname
        self.firstname = firstname
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = createdAt
    }
}

