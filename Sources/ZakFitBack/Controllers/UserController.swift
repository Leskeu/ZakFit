//
//  UserController.swift
//  ZakFitBack
//
//  Created by Leskeu  on 24/11/2026.
//

import Fluent
import Vapor
import JWT

struct UserController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {

        routes.post("register", use: create)
        routes.post("login", use: login)

        let privateRoutes = routes.grouped(JWTMiddleware())
        privateRoutes.get("me", use: getMe)
    }

    @Sendable
    func create(req: Request) async throws -> UserResponseDTO {

        let userRequest = try req.content.decode(CreateUserDTO.self)

        guard try await User
            .query(on: req.db)
            .filter(\.$email == userRequest.email)
            .first() == nil else {
            throw Abort(.conflict, reason: "Email already exists")
        }

        let passwordHash = try Bcrypt.hash(userRequest.password)

        let user = User(
            lastname: userRequest.lastname,
            firstname: userRequest.firstname,
            email: userRequest.email,
            passwordHash: passwordHash
        )

        try await user.save(on: req.db)

        return UserResponseDTO(user: user)
    }

    @Sendable
    func login(req: Request) async throws -> AuthDTO {

        let userRequest = try req.content.decode(LoginRequestDTO.self)

        guard let userDB = try await User
            .query(on: req.db)
            .filter(\.$email == userRequest.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Authentication failed")
        }

        guard try Bcrypt.verify(
            userRequest.password,
            created: userDB.passwordHash
        ) else {
            throw Abort(.unauthorized, reason: "Authentication failed")
        }

        guard let userID = userDB.id else {
            throw Abort(.internalServerError)
        }

        let payload = UserPayload(id: userID)

        guard let secret = Environment.get("JWT_SECRET"),
              !secret.isEmpty else {
            throw Abort(.internalServerError, reason: "JWT secret not configured")
        }

        let signer = JWTSigner.hs256(key: secret)
        let jwtToken = try signer.sign(payload)

        return AuthDTO(token: jwtToken)
    }
    
    @Sendable
    func getMe(req: Request) async throws -> UserResponseDTO {

        let payload = try req.auth.require(UserPayload.self)

        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        return UserResponseDTO(user: user)
    }
}
