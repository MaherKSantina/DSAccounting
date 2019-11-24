//
//  File.swift
//  
//
//  Created by Maher Santina on 11/17/19.
//

import Foundation
import Vapor
import FluentMySQL

public protocol DSAccountingDatabaseConfigurable {
    var dsAccountingDatabaseHostName: String { get }
    var dsAccountingDatabasePort: Int { get }
    var dsAccountingDatabaseUsername: String { get }
    var dsAccountingDatabasePassword: String { get }
    var dsAccountingDatabaseDatabase: String { get }
    var dsAccountingDatabaseTestDatabase: String { get }
}

public class DSAccountingMain {

    let dataSource: DSAccountingDatabaseConfigurable

    public init(dataSource: DSAccountingDatabaseConfigurable) {
        self.dataSource = dataSource
    }

    public func accountingConfigure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
        // Register providers first
        try services.register(FluentProvider())
        try services.register(MySQLProvider())

        var commandConfig = CommandConfig.default()
        commandConfig.useFluentCommands()
        services.register(commandConfig)

        var databases = DatabasesConfig()

        var databaseName: String = ""
        switch env {
        case .testing:
            databaseName = dataSource.dsAccountingDatabaseTestDatabase
        default:
            databaseName = dataSource.dsAccountingDatabaseDatabase
        }

        let mysql = MySQLDatabase(config: MySQLDatabaseConfig(
            hostname: dataSource.dsAccountingDatabaseHostName,
            port: dataSource.dsAccountingDatabasePort,
            username: dataSource.dsAccountingDatabaseUsername,
            password: dataSource.dsAccountingDatabasePassword,
            database: databaseName
            )
        )
        databases.add(database: mysql, as: .mysql)
        services.register(databases)


        // Configure migrations
        var migrations = MigrationConfig()
        migrations.add(migration: EnableReferencesMigration.self, database: .mysql)

        migrations.add(model: InvoiceRow.self, database: .mysql)
        migrations.add(model: InvoiceItemRow.self, database: .mysql)

        migrations.add(migration: Invoice_InvoiceItemRow.self, database: .mysql)

        migrations.add(model: QuotationRow.self, database: .mysql)
        migrations.add(migration: QuotationItemRow.self, database: .mysql)

        services.register(migrations)
    }
}
