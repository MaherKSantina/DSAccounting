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
}

extension InvoiceRow: DSModel {
    public static func routePath() throws -> String {
        return "invoice"
    }

    public static var entity: String = "Invoice"
}
