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

    public struct Full: MySQLModel {
        public var id: Int?
        public var totalPrice: Double
        public var items: [InvoiceItemRow]

        public init(id: Int?, totalPrice: Double, items: [InvoiceItemRow]) {
            self.id = id
            self.totalPrice = totalPrice
            self.items = items
        }
    }

    public struct Post: Content {
        var id: Int?
        var totalPrice: Double
        var items: [InvoiceItemRow.Post]

        public init(id: Int?, totalPrice: Double, items: [InvoiceItemRow.Post]) {
            self.id = id
            self.totalPrice = totalPrice
            self.items = items
        }
    }
}

extension InvoiceRow: DSModel {
    public static func routePath() throws -> String {
        return "invoice"
    }

    public static var entity: String = "Invoice"
}

extension InvoiceRow: Hashable {

    public static func == (lhs: InvoiceRow, rhs: InvoiceRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
