//
//  File.swift
//  
//
//  Created by Maher Santina on 11/17/19.
//

import Foundation
import Vapor
import FluentMySQL

public class DSAccountingMain {

    public init() { }

    public func configure(migrations: inout MigrationConfig) throws {

//        migrations.add(migration: EnableReferencesMigration.self, database: .mysql)

        migrations.add(model: InvoiceRow.self, database: .mysql)
        migrations.add(model: InvoiceItemRow.self, database: .mysql)

        migrations.add(migration: Invoice_InvoiceItemRow.self, database: .mysql)

//        migrations.add(model: QuotationRow.self, database: .mysql)
//        migrations.add(migration: QuotationItemRow.self, database: .mysql)
//        migrations.add(migration: Quotation_QuotationItemRow.self, database: .mysql)
    }
}
