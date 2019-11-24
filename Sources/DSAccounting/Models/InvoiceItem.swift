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
}

extension InvoiceItemRow: DSModel {
    public static func routePath() throws -> String {
        return "invoiceItem"
    }

    public static var entity: String = "InvoiceItem"
}
