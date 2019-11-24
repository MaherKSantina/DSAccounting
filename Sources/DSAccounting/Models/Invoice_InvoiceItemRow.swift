//
//  File.swift
//  
//
//  Created by Maher Santina on 11/24/19.
//

import Foundation
import DSCore
import FluentMySQL

public struct Invoice_InvoiceItemRow {
    public var Invoice_id: Int?
    public var Invoice_totalPrice: Double

    public var InvoiceItem_id: Int?
    public var InvoiceItem_invoiceID: InvoiceRow.ID
    public var InvoiceItem_name: String
    public var InvoiceItem_quantity: Double
    public var InvoiceItem_unitPrice: Double
    public var InvoiceItem_totalPrice: Double
}

extension Invoice_InvoiceItemRow: TwoModelJoin {
    public typealias Model1 = InvoiceRow
    public typealias Model2 = InvoiceItemRow

    public static var model1selectFields: [String] {
        return InvoiceRow.CodingKeys.allCases.map{ $0.rawValue }
    }

    public static var model2selectFields: [String] {
        return InvoiceItemRow.CodingKeys.allCases.map{ $0.rawValue }
    }

    public static var join: JoinRelationship {
        return JoinRelationship(type: .left, key1: Model1.CodingKeys.id.rawValue, key2: Model2.CodingKeys.invoiceID.rawValue)
    }
}

extension Invoice_InvoiceItemRow: DSModelView {
    public typealias Database = MySQLDatabase
}
