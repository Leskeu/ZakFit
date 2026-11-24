import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

func configure(_ app: Application) async throws {

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "zakfit",
        tlsConfiguration: nil
    ), as: .mysql)

    let corsMiddleware = CORSMiddleware(
        configuration: .init(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE, .OPTIONS],
            allowedHeaders: [.accept, .authorization, .contentType, .origin]
        )
    )

    app.middleware.use(corsMiddleware)
    
    try routes(app)
}
