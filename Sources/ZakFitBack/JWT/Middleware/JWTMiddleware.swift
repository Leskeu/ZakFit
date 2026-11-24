//
//  JWTMiddleware.swift
//  ZakFitBack
//
//  Created by Leskeu  on 24/11/2026.
//

import Vapor
import JWT

final class JWTMiddleware: Middleware {

    func respond(
        to request: Request,
        chainingTo next: any Responder
    ) -> EventLoopFuture<Response> {

        guard let token = request.headers.bearerAuthorization?.token else {
            return request.eventLoop.future(
                error: Abort(.unauthorized, reason: "Missing token")
            )
        }

        guard let secret = Environment.get("JWT_SECRET"),
              !secret.isEmpty else {
            return request.eventLoop.future(
                error: Abort(.internalServerError, reason: "JWT secret not configured")
            )
        }

        let signer = JWTSigner.hs256(key: secret)

        let payload: UserPayload

        do {
            payload = try signer.verify(token, as: UserPayload.self)
        } catch {
            return request.eventLoop.future(
                error: Abort(.unauthorized, reason: "Invalid token")
            )
        }

        request.auth.login(payload)

        return next.respond(to: request)
    }
}
