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

    enum CodingKeys: String, CodingKey {
        case Invoice_id
        case Invoice_totalPrice
        case InvoiceItem_id
        case InvoiceItem_invoiceID
        case InvoiceItem_name
        case InvoiceItem_quantity
        case InvoiceItem_unitPrice
        case InvoiceItem_totalPrice
    }

    public var Invoice_id: Int?
    public var Invoice_totalPrice: Double

    public var InvoiceItem_id: Int?
    public var InvoiceItem_invoiceID: InvoiceRow.ID?
    public var InvoiceItem_name: String?
    public var InvoiceItem_quantity: Double?
    public var InvoiceItem_unitPrice: Double?
    public var InvoiceItem_totalPrice: Double?

    var invoiceItem: Invoice.Item? {
        guard let id = InvoiceItem_id,
            let name = InvoiceItem_name,
            let quantity = InvoiceItem_quantity,
            let unitPrice = InvoiceItem_unitPrice,
            let totalPrice = InvoiceItem_totalPrice else { return nil }
        return .init(id: id, name: name, quantity: quantity, unitPrice: unitPrice, totalPrice: totalPrice)
    }
}

extension Invoice_InvoiceItemRow: DSNModelView {
    public static var tables: [DSViewTable] {
        return [
            DSViewTable(name: InvoiceRow.entity, fields: InvoiceRow.CodingKeys.allCases.map{ $0.rawValue }),
            DSViewTable(name: InvoiceItemRow.entity, fields: InvoiceItemRow.CodingKeys.allCases.map{ $0.rawValue })
        ]
    }

    public static var mainTableName: String {
        return tables.first!.name
    }

    public static var joins: [DSViewJoin] {
        return [
            DSViewJoin(type: .left, foreignTable: InvoiceItemRow.entity, foreignKey: InvoiceItemRow.CodingKeys.invoiceID.rawValue, mainTable: mainTableName, mainTableKey: InvoiceRow.CodingKeys.id.rawValue)
        ]
    }

    public static var model1selectFields: [String] {
        return InvoiceRow.CodingKeys.allCases.map{ $0.rawValue }
    }

    public static var model2selectFields: [String] {
        return InvoiceItemRow.CodingKeys.allCases.map{ $0.rawValue }
    }
}

extension Array where Element == Invoice_InvoiceItemRow {
    public func toFullList() -> [Invoice] {
        let items = self.filter{ $0.Invoice_id != nil }
        return Dictionary(grouping: items) { $0.Invoice_id }.map { (arg) -> Invoice in
            return arg.value.toOneItem
        }
    }

    public var toOneItem: Invoice {
        let items = self.compactMap{ $0.invoiceItem }
        let invoice = self.first!
        return Invoice(id: invoice.Invoice_id, totalPrice: invoice.Invoice_totalPrice, items: items)
    }
}
