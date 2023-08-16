import XCTest
import Tree

final class TreeTrunkTests: XCTestCase {
  func testEmptyAtFirst() {
    var tt = TreeTrunk(stack: [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 0, isLast: true)), [])
  }

  func testOneChild() {
    var tt = TreeTrunk(stack: [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 0, isLast: true)), [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: true)), [.corner])
  }

  func testTwoChildren() {
    var tt = TreeTrunk(stack: [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 0, isLast: true)), [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: false)), [.edge])
    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: true)), [.corner])
  }

  func testTwoTimesTwoChildren() {
    var tt = TreeTrunk(stack: [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 0, isLast: false)), [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: false)), [.edge])
    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: true)), [.corner])

    XCTAssertEqual(tt.newRow(params: .init(depth: 0, isLast: true)), [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: false)), [.edge])
    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: true)), [.corner])
  }

  func testTwoTimesTwoNestedChildren() {
    var tt = TreeTrunk(stack: [])
    XCTAssertEqual(tt.newRow(params: .init(depth: 0, isLast: true)), [])

    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: false)), [.edge])
    XCTAssertEqual(tt.newRow(params: .init(depth: 2, isLast: false)), [.line, .edge])
    XCTAssertEqual(tt.newRow(params: .init(depth: 2, isLast: true)), [.line, .corner])

    XCTAssertEqual(tt.newRow(params: .init(depth: 1, isLast: true)), [.corner])
    XCTAssertEqual(tt.newRow(params: .init(depth: 2, isLast: false)), [.blank, .edge])
    XCTAssertEqual(tt.newRow(params: .init(depth: 2, isLast: true)), [.blank, .corner])
  }
}
