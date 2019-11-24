//
//  Quotation.swift
//  App
//
//  Created by Maher Santina on 5/5/19.
//

import Vapor
import Fluent
import FluentMySQL
import DSCore

public struct QuotationRow {

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
        public var items: [QuotationItemRow]

        public init(id: Int?, totalPrice: Double, items: [QuotationItemRow]) {
            self.id = id
            self.totalPrice = totalPrice
            self.items = items
        }
    }
}

extension QuotationRow: DSModel {
    public static func routePath() throws -> String {
        return "quotation"
    }

    public static var entity: String = "Quotation"
}

extension QuotationRow: Hashable {

    public static func == (lhs: QuotationRow, rhs: QuotationRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
