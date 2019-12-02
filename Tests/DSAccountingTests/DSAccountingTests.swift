import Vapor
import XCTest
import DSAccounting

final class AppTests: WMSTestCase {

    func testInvoiceInvoiceItemToList_ShouldMapProperly() throws {
        let invoice1 = try InvoiceRow(id: nil, totalPrice: 1000).save(on: conn).wait()
        let invoice2 = try InvoiceRow(id: nil, totalPrice: 2000).save(on: conn).wait()
        let invoice1Item1 = try InvoiceItemRow(id: nil, invoiceID: try invoice1.requireID(), name: "Name", quantity: 1, unitPrice: 1, totalPrice: 1).save(on: conn).wait()
        let invoice1Item2 = try InvoiceItemRow(id: nil, invoiceID: try invoice1.requireID(), name: "Name", quantity: 2, unitPrice: 2, totalPrice: 2).save(on: conn).wait()
        let invoice2Item1 = try InvoiceItemRow(id: nil, invoiceID: try invoice2.requireID(), name: "Name", quantity: 1, unitPrice: 1, totalPrice: 1).save(on: conn).wait()
        let invoice2Item2 = try InvoiceItemRow(id: nil, invoiceID: try invoice2.requireID(), name: "Name", quantity: 2, unitPrice: 2, totalPrice: 2).save(on: conn).wait()

        let all = try Invoice_InvoiceItemRow.query(onlyOne: false).all(on: conn).wait()
        let mapped = all.toFullList()
        XCTAssertEqual(mapped.count, 2)
        guard let items2 = try mapped.first(where: { $0.id == invoice2.id })?.items.sorted(by: { try $0.requireID() < $1.requireID() }) else { XCTFail(); return }
        XCTAssertEqual(items2[1], invoice2Item2)
        XCTAssertEqual(items2[0], invoice2Item1)

        guard let items1 = try mapped.first(where: { $0.id == invoice1.id })?.items.sorted(by: { try $0.requireID() < $1.requireID() }) else { XCTFail(); return }
        XCTAssertEqual(items1[1], invoice1Item2)
        XCTAssertEqual(items1[0], invoice1Item1)
    }

    func testQuotationQuotationItemToList_ShouldMapProperly() throws {
        let quotation1 = try QuotationRow(id: nil, totalPrice: 1000).save(on: conn).wait()
        let quotation2 = try QuotationRow(id: nil, totalPrice: 2000).save(on: conn).wait()
        let invoice1Item1 = try QuotationItemRow(id: nil, quotationID: try quotation1.requireID(), name: "Name", quantity: 1, unitPrice: 1, totalPrice: 1).save(on: conn).wait()
        let invoice1Item2 = try QuotationItemRow(id: nil, quotationID: try quotation1.requireID(), name: "Name", quantity: 2, unitPrice: 2, totalPrice: 2).save(on: conn).wait()
        let invoice2Item1 = try QuotationItemRow(id: nil, quotationID: try quotation2.requireID(), name: "Name", quantity: 1, unitPrice: 1, totalPrice: 1).save(on: conn).wait()
        let invoice2Item2 = try QuotationItemRow(id: nil, quotationID: try quotation2.requireID(), name: "Name", quantity: 2, unitPrice: 2, totalPrice: 2).save(on: conn).wait()

        let all = try Quotation_QuotationItemRow.query(onlyOne: false).all(on: conn).wait()
        let mapped = all.toFullList()
        XCTAssertEqual(mapped.count, 2)
        guard let items2 = try mapped.first(where: { $0.id == quotation2.id })?.items.sorted(by: { try $0.requireID() < $1.requireID() }) else { XCTFail(); return }
        XCTAssertEqual(items2[1], invoice2Item2)
        XCTAssertEqual(items2[0], invoice2Item1)

        guard let items1 = try mapped.first(where: { $0.id == quotation1.id })?.items.sorted(by: { try $0.requireID() < $1.requireID() }) else { XCTFail(); return }
        XCTAssertEqual(items1[1], invoice1Item2)
        XCTAssertEqual(items1[0], invoice1Item1)
    }

    func testCreateInvoice_WithNoItems_ShouldCreateProperly() throws {
        let full = InvoiceRow.Post(id: nil, totalPrice: 1000, items: [])
        let invoice = try createInvoice(invoice: full, on: conn).wait()
        XCTAssertEqual(invoice.totalPrice, 1000)
        XCTAssertEqual(invoice.items.count, 0)
    }

    func testCreateInvoice_WithItems_ShouldCreateProperly() throws {
        let invoiceItem1 = InvoiceItemRow.Post(id: nil, name: "itme 1", quantity: 1, unitPrice: 1, totalPrice: 1)
        let invoiceItem2 = InvoiceItemRow.Post(id: nil, name: "itme 2", quantity: 2, unitPrice: 2, totalPrice: 2)
        let full = InvoiceRow.Post(id: nil, totalPrice: 1000, items: [invoiceItem1, invoiceItem2])
        let invoice = try createInvoice(invoice: full, on: conn).wait()
        XCTAssertEqual(invoice.totalPrice, 1000)
        XCTAssertEqual(invoice.items.count, 2)
    }

    static let allTests = [
        ("testInvoiceInvoiceItemToList_ShouldMapProperly", testInvoiceInvoiceItemToList_ShouldMapProperly)
    ]
}
