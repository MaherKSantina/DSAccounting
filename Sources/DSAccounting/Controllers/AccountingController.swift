//
//  File.swift
//  
//
//  Created by Maher Santina on 11/24/19.
//

import Foundation
import Vapor
import FluentMySQL

public struct Invoice {
    public static func all(on conn: DatabaseConnectable) -> Future<[InvoiceRow]> {
        return InvoiceRow.query(on: conn).all()
    }
}

public func createInvoice(invoice: InvoiceRow.Post, on conn: MySQLConnection) -> Future<InvoiceRow.Full> {
    InvoiceRow(id: invoice.id, totalPrice: invoice.totalPrice).save(on: conn).flatMap { (invoiceRow) -> EventLoopFuture<InvoiceRow> in
        return try invoice.items.map{ $0.invoiceItemRow(invoiceID: try invoiceRow.requireID()) }.save(on: conn).map{ _ in return invoiceRow }
    }
    .flatMap{ Invoice_InvoiceItemRow.find(id: try $0.requireID(), on: conn) }
    .map{ $0.toFullList().first }.unwrap(or: Abort(.notFound))
}
