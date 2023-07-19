import Fluent
import FluentSQLiteDriver
import Leaf
import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(
        FileMiddleware(
            publicDirectory: app.directory.publicDirectory, defaultFile: "index.html",
            directoryAction: .redirect))


    app.databases.use(.sqlite(.file(app.directory.publicDirectory + "database.db")), as: .sqlite)

    //app.migrations.add(CreateDepartment())

    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateCompleteUser())
    app.migrations.add(CreateAppointment())
    app.migrations.add(CreateProfile())
    
    
    try await app.autoMigrate()
    app.views.use(.leaf)

    // register routes
    try routes(app)
}
