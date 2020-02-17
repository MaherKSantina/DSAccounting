//
//  Invoice.swift
//  App
//
//  Created by Maher Santina on 4/28/19.
//

import Vapor
import Fluent
import FluentMySQL
import DSCore

public struct Invoice: Content {

    enum CodingKeys: String, CodingKey {
        case id
        case totalPrice
        case items
    }

    public struct Item: Content {

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case quantity
            case unitPrice
            case totalPrice
        }

        public var id: Int?
        public var name: String
        public var quantity: Double
        public var unitPrice: Double
        public var totalPrice: Double

        public init(id: Int?, name: String, quantity: Double, unitPrice: Double, totalPrice: Double) {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.unitPrice = unitPrice
            self.totalPrice = totalPrice
        }

        func invoiceItemRow(invoiceID: Int) -> InvoiceItemRow {
            return InvoiceItemRow(id: id, invoiceID: invoiceID, name: name, quantity: quantity, unitPrice: unitPrice, totalPrice: totalPrice)
        }

    }

    public var id: Int?
    public var totalPrice: Double
    public var items: [Item]

    public init(id: Int?, totalPrice: Double, items: [Item]) {
        self.id = id
        self.totalPrice = totalPrice
        self.items = items
    }
}

public struct InvoiceRow {

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case totalPrice
    }

    public var id: Int?
    public var totalPrice: Double

    public init(id: Int?, totalPrice: Double) {
        self.id = id
        self.totalPrice = totalPrice
    }
}

extension InvoiceRow: DSModel {

    public static var entity: String = "Invoice"
}

extension Invoice {
    public func save(on conn: DatabaseConnectable) -> Future<Invoice> {
        return InvoiceRow(id: id, totalPrice: totalPrice).save(on: conn).flatMap{ invoiceRow in
            return self.items.map{ $0.invoiceItemRow(invoiceID: try! invoiceRow.requireID()) }.map{ $0.save(on: conn) }.flatten(on: conn).map{ _ in return invoiceRow }
        }.flatMap { (invoiceRow) -> Future<Invoice> in
            return Invoice_InvoiceItemRow.all(where: "\(Invoice_InvoiceItemRow.CodingKeys.Invoice_id.rawValue) = \(try! invoiceRow.requireID())", req: conn).map{ $0.toOneItem }
        }
    }
}

