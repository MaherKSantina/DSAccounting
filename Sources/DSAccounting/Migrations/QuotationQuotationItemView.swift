//
//  InvoiceInvoiceItemView.swift
//  App
//
//  Created by Maher Santina on 5/11/19.
//

import Vapor
import FluentMySQL

struct QuotationQuotationItemView: Migration {
    static func prepare(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return conn.raw("CREATE VIEW `QuotationQuotationItemView` AS SELECT `Quotation`.`id` AS `quotation_id`, `Quotation`.`workOrderID` AS `quotation_workOrderID`, `Quotation`.`totalPrice` AS `quotation_totalPrice`, `QuotationItem`.`id` AS `quotationitem_id`, `QuotationItem`.`quotationID` AS `quotationitem_quotationID`, `QuotationItem`.`name` AS `quotationitem_name`, `QuotationItem`.`quantity` AS `quotationitem_quantity`, `QuotationItem`.`unitPrice` AS `quotationitem_unitPrice`, `QuotationItem`.`totalPrice` AS `quotationitem_totalPrice` FROM (`Quotation` LEFT JOIN `QuotationItem` ON ((`QuotationItem`.`quotationID` = `Quotation`.`id`)))").run()
    }
    
    static func revert(on conn: MySQLConnection) -> EventLoopFuture<Void> {
        return conn.raw("DROP VIEW IF Exists `QuotationQuotationItemView`").run()
    }
    
    typealias Database = MySQLDatabase
    
    
}
