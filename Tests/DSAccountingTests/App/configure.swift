import Vapor
import DSAccounting
import FluentMySQL
import Fluent
import DSCore

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
        try services.register(FluentProvider())
        try services.register(MySQLProvider())

        var commandConfig = CommandConfig.default()
        commandConfig.useFluentCommands()
        services.register(commandConfig)

        var databases = DatabasesConfig()

        let mysql = MySQLDatabase(config: MySQLDatabaseConfig(
            hostname: "localhost",
            port: 3306,
            username: "root",
            password: "root",
            database: "accounting-test"
            )
        )
        databases.add(database: mysql, as: .mysql)
        services.register(databases)

        let auth = DSAccountingMain()
        var migrations = MigrationConfig()
        try auth.configure(migrations: &migrations)
        services.register(migrations)
}
