//
//  File.swift
//  
//
//  Created by Maher Santina on 11/24/19.
//

import Foundation
import Vapor
import DSCore
import FluentMySQL

public struct Quotation_QuotationItemRow {
    public var Quotation_id: Int?
    public var Quotation_totalPrice: Double

    public var QuotationItem_id: Int?
    public var QuotationItem_quotationID: QuotationRow.ID
    public var QuotationItem_name: String
    public var QuotationItem_quantity: Double
    public var QuotationItem_unitPrice: Double
    public var QuotationItem_totalPrice: Double

    public var quotationRow: QuotationRow {
        return QuotationRow(id: Quotation_id, totalPrice: Quotation_totalPrice)
    }

    public var quotationItemRow: QuotationItemRow {
        return QuotationItemRow(id: QuotationItem_id, quotationID: QuotationItem_quotationID, name: QuotationItem_name, quantity: QuotationItem_quantity, unitPrice: QuotationItem_unitPrice, totalPrice: QuotationItem_totalPrice)
    }
    
}

extension Quotation_QuotationItemRow: TwoModelJoin {
    public typealias Model1 = QuotationRow
    public typealias Model2 = QuotationItemRow

    public static var model1selectFields: [String] {
        return QuotationRow.CodingKeys.allCases.map{ $0.rawValue }
    }

    public static var model2selectFields: [String] {
        return QuotationItemRow.CodingKeys.allCases.map{ $0.rawValue }
    }

    public static var join: JoinRelationship {
        return JoinRelationship(type: .left, key1: Model1.CodingKeys.id.rawValue, key2: Model2.CodingKeys.quotationID.rawValue)
    }
}

extension Quotation_QuotationItemRow: DSModelView {
    public typealias Database = MySQLDatabase
}

extension Array where Element == Quotation_QuotationItemRow {
    public func toFullList() -> [QuotationRow.Full] {
        let items = self.filter{ $0.Quotation_id != nil }
        return Dictionary(grouping: items) { $0.quotationRow }.map { (arg) -> QuotationRow.Full in

            let (key, value) = arg
            return QuotationRow.Full(id: key.id, totalPrice: key.totalPrice, items: value.map{ $0.quotationItemRow })
        }
    }
}
