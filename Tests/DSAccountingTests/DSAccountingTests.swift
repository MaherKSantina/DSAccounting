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

        let all = try Invoice_InvoiceItemRow.all(where: nil, req: conn).wait()
        let mapped = all.toFullList()
        XCTAssertEqual(mapped.count, 2)
        guard let items2 = mapped.first(where: { $0.id == invoice2.id })?.items.sorted(by: { $0.id! < $1.id! }) else { XCTFail(); return }
        XCTAssertEqual(items2[1].id!, invoice2Item2.id!)
        XCTAssertEqual(items2[0].id!, invoice2Item1.id!)

        guard let items1 = mapped.first(where: { $0.id == invoice1.id })?.items.sorted(by: { $0.id! < $1.id! }) else { XCTFail(); return }
        XCTAssertEqual(items1[1].id!, invoice1Item2.id!)
        XCTAssertEqual(items1[0].id!, invoice1Item1.id!)
    }

    func testInvoiceSave_ShouldSaveProperly() throws {
        let item1 = Invoice.Item(id: nil, name: "Invoice Item 1", quantity: 1, unitPrice: 1000, totalPrice: 1000)
        let item2 = Invoice.Item(id: nil, name: "Invoice Item 2", quantity: 2, unitPrice: 2000, totalPrice: 4000)
        let invoice = Invoice(id: nil, totalPrice: 5000, items: [item1, item2])
        let _ = try invoice.save(on: conn).wait()
        let items = try Invoice_InvoiceItemRow.all(where: nil, req: conn).wait()
        XCTAssertEqual(items.count, 2)
    }

    func testInvoiceUpdate_ShouldUpdateProperly() throws {
        let invoice = try InvoiceRow(id: nil, totalPrice: 1000).save(on: conn).wait()
        let item1 = try InvoiceItemRow(id: nil, invoiceID: try invoice.requireID(), name: "Item 1", quantity: 1, unitPrice: 100, totalPrice: 100).save(on: conn).wait()
        let item2 = try InvoiceItemRow(id: nil, invoiceID: try invoice.requireID(), name: "Item 2", quantity: 1, unitPrice: 100, totalPrice: 100).save(on: conn).wait()

        let updateInvoiceItem1 = Invoice.Item(id: try item1.requireID(), name: "Item Updated 1", quantity: 2, unitPrice: 500, totalPrice: 1000)
        let updateInvoiceItem2 = Invoice.Item(id: try item2.requireID(), name: "Item Updated 2", quantity: 2, unitPrice: 500, totalPrice: 1000)
        let updatedInvoice = Invoice(id: try invoice.requireID(), totalPrice: 500, items: [updateInvoiceItem1, updateInvoiceItem2])
        let _ = try updatedInvoice.save(on: conn).wait()
        let items = try Invoice_InvoiceItemRow.all(where: nil, req: conn).wait()
        XCTAssertEqual(500, items.first?.Invoice_totalPrice)
        XCTAssertEqual("Item Updated 1", items.first?.InvoiceItem_name)
        XCTAssertEqual(1000, items[1].InvoiceItem_totalPrice)
        XCTAssertEqual("Item Updated 2", items[1].InvoiceItem_name)
    }
//
//    func testQuotationQuotationItemToList_ShouldMapProperly() throws {
//        let quotation1 = try QuotationRow(id: nil, totalPrice: 1000).save(on: conn).wait()
//        let quotation2 = try QuotationRow(id: nil, totalPrice: 2000).save(on: conn).wait()
//        let invoice1Item1 = try QuotationItemRow(id: nil, quotationID: try quotation1.requireID(), name: "Name", quantity: 1, unitPrice: 1, totalPrice: 1).save(on: conn).wait()
//        let invoice1Item2 = try QuotationItemRow(id: nil, quotationID: try quotation1.requireID(), name: "Name", quantity: 2, unitPrice: 2, totalPrice: 2).save(on: conn).wait()
//        let invoice2Item1 = try QuotationItemRow(id: nil, quotationID: try quotation2.requireID(), name: "Name", quantity: 1, unitPrice: 1, totalPrice: 1).save(on: conn).wait()
//        let invoice2Item2 = try QuotationItemRow(id: nil, quotationID: try quotation2.requireID(), name: "Name", quantity: 2, unitPrice: 2, totalPrice: 2).save(on: conn).wait()
//
//        let all = try Quotation_QuotationItemRow.query(onlyOne: false).all(on: conn).wait()
//        let mapped = all.toFullList()
//        XCTAssertEqual(mapped.count, 2)
//        guard let items2 = try mapped.first(where: { $0.id == quotation2.id })?.items.sorted(by: { try $0.requireID() < $1.requireID() }) else { XCTFail(); return }
//        XCTAssertEqual(items2[1], invoice2Item2)
//        XCTAssertEqual(items2[0], invoice2Item1)
//
//        guard let items1 = try mapped.first(where: { $0.id == quotation1.id })?.items.sorted(by: { try $0.requireID() < $1.requireID() }) else { XCTFail(); return }
//        XCTAssertEqual(items1[1], invoice1Item2)
//        XCTAssertEqual(items1[0], invoice1Item1)
//    }
//
//    func testCreateInvoice_WithNoItems_ShouldCreateProperly() throws {
//        let full = InvoiceRow.Post(id: nil, totalPrice: 1000, items: [])
//        let invoice = try createInvoice(invoice: full, on: conn).wait()
//        XCTAssertEqual(invoice.totalPrice, 1000)
//        XCTAssertEqual(invoice.items.count, 0)
//    }
//
//    func testCreateInvoice_WithItems_ShouldCreateProperly() throws {
//        let invoiceItem1 = InvoiceItemRow.Post(id: nil, name: "itme 1", quantity: 1, unitPrice: 1, totalPrice: 1)
//        let invoiceItem2 = InvoiceItemRow.Post(id: nil, name: "itme 2", quantity: 2, unitPrice: 2, totalPrice: 2)
//        let full = InvoiceRow.Post(id: nil, totalPrice: 1000, items: [invoiceItem1, invoiceItem2])
//        let invoice = try createInvoice(invoice: full, on: conn).wait()
//        XCTAssertEqual(invoice.totalPrice, 1000)
//        XCTAssertEqual(invoice.items.count, 2)
//    }
//
//    static let allTests = [
//        ("testInvoiceInvoiceItemToList_ShouldMapProperly", testInvoiceInvoiceItemToList_ShouldMapProperly)
//    ]
}
