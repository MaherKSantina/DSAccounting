//
//  QuotationItem.swift
//  App
//
//  Created by Maher Santina on 5/5/19.
//

import Vapor
import FluentMySQL
import DSCore

public struct QuotationItemRow {
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case quotationID
        case name
        case quantity
        case unitPrice
        case totalPrice
    }

    public var id: Int?
    public var quotationID: QuotationRow.ID
    public var name: String
    public var quantity: Double
    public var unitPrice: Double
    public var totalPrice: Double

    public init(id: Int?, quotationID: QuotationRow.ID, name: String, quantity: Double, unitPrice: Double, totalPrice: Double) {
        self.id = id
        self.quotationID = quotationID
        self.name = name
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
    }
}

extension QuotationItemRow: DSModel {
    public static func routePath() throws -> String {
        return "quotationItem"
    }
}
