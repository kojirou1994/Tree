import XCTest
import Tree

final class IterTests: XCTestCase {
  func testIteration() throws {
    let foos = [ "first", "middle", "last" ]
    var iter = TreeDepth.root.iterateOver(foos)

    do {
      let next = try XCTUnwrap(iter.next())
      XCTAssertEqual("first", next.1)
      XCTAssertFalse(next.0.isLast)
    }

    do {
      let next = try XCTUnwrap(iter.next())
      XCTAssertEqual("middle", next.1)
      XCTAssertFalse(next.0.isLast)
    }

    do {
      let next = try XCTUnwrap(iter.next())
      XCTAssertEqual("last", next.1)
      XCTAssertTrue(next.0.isLast)
    }

    XCTAssertNil(iter.next())
  }

  func testEmpty() {
    let nothing = [Int]()
    var iter = TreeDepth.root.iterateOver(nothing)
    XCTAssertNil(iter.next())
  }
}
