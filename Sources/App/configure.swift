import Fluent
//import FluentSQLiteDriver
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

  //  app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
 
    //PostgreSQL
    
    
    
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:))  ??  5432,
        username: Environment.get("DATABASE_USER") ?? "vapor_user",
        password: Environment.get("DATABASE_PASS") ?? "vapor_pass",
        database: Environment.get("DATABASE_NAME") ?? "vapor_dbname",
        tlsConfiguration: .forClient(certificateVerification: .none)
    ), as: .psql)    
    
    //Aqui las migraciones MOdelo datos
    app.migrations.add(Bootcamps_v1())
    app.migrations.add(Developers_v1())
    app.migrations.add(CreateUsersApp_v1())
    app.migrations.add(Heros_v1())
    app.migrations.add(HerosLocations_v1())
    app.migrations.add(DevelopersHeros_v1())
    app.migrations.add(HerosTransformations_v1())
    
    
    // Aqui datos por defecto
    app.migrations.add(Create_Data_v1()) //creamos los bootcamps
    app.migrations.add(Create_Data_Heros_v1()) // cramos los heroes Dragon Ball
    
    //encriptacion del sistema
    app.passwords.use(.bcrypt)
    
    //JWT Config
    app.jwt.signers.use(.hs256(key: "2022KeepCoding2022"))
    
    
    // register routes
    try routes(app)
}
