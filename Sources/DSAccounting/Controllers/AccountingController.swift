//
//  File.swift
//  
//
//  Created by Maher Santina on 11/24/19.
//

import Foundation
import Vapor
import FluentMySQL

public struct Invoice {
    public static func all(on conn: DatabaseConnectable) -> Future<[InvoiceRow]> {
        return InvoiceRow.query(on: conn).all()
    }
}
