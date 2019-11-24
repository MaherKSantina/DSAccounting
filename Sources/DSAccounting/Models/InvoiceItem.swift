//
//  InvoiceItem.swift
//  App
//
//  Created by Maher Santina on 4/28/19.
//

import Vapor
import FluentMySQL
import DSCore

public struct InvoiceItemRow {

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case invoiceID
        case quantity
        case unitPrice
        case totalPrice
    }

    public var id: Int?
    public var invoiceID: InvoiceRow.ID
    public var name: String
    public var quantity: Double
    public var unitPrice: Double
    public var totalPrice: Double

    public init(id: Int?, invoiceID: InvoiceRow.ID, name: String, quantity: Double, unitPrice: Double, totalPrice: Double) {
        self.id = id
        self.invoiceID = invoiceID
        self.name = name
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
    }

    public init?(invoiceInvoiceItemRow: Invoice_InvoiceItemRow) {
        guard let invoiceID = invoiceInvoiceItemRow.InvoiceItem_invoiceID, let name = invoiceInvoiceItemRow.InvoiceItem_name, let quantity = invoiceInvoiceItemRow.InvoiceItem_quantity, let unitPrice = invoiceInvoiceItemRow.InvoiceItem_unitPrice, let totalPrice = invoiceInvoiceItemRow.InvoiceItem_totalPrice else { return nil }
        self.id = invoiceInvoiceItemRow.InvoiceItem_id
        self.name = name
        self.invoiceID = invoiceID
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
    }

    public struct Post: Content {
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

        public func invoiceItemRow(invoiceID: InvoiceRow.ID) -> InvoiceItemRow {
            return InvoiceItemRow(id: id, invoiceID: invoiceID, name: name, quantity: quantity, unitPrice: unitPrice, totalPrice: totalPrice)
        }
    }
}

extension InvoiceItemRow: DSModel {
    public static func routePath() throws -> String {
        return "invoiceItem"
    }

    public static var entity: String = "InvoiceItem"
}

extension InvoiceItemRow: Equatable {
    public static func == (lhs: InvoiceItemRow, rhs: InvoiceItemRow) -> Bool {
        return lhs.id == rhs.id
    }
}
