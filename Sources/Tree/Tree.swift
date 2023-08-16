public enum TreePart {

  /// Rightmost column, *not* the last in the directory.
  case edge

  /// Not the rightmost column, and the directory has not finished yet.
  case line

  /// Rightmost column, and the last in the directory.
  case corner

  /// Not the rightmost column, and the directory *has* finished.
  case blank
}

extension TreePart {
  public var asciiArt: String {
    switch self {
    case .edge:    return "├──"
    case .line:    return "│  "
    case .corner:  return "└──"
    case .blank:   return "   "
    }
  }
}

/// A **tree trunk** builds up arrays of tree parts over multiple depths.
public struct TreeTrunk {
  public init(stack: [TreePart] = []) {
    self.stack = stack
  }


  /// A stack tracks which tree characters should be printed. It’s
  /// necessary to maintain information about the previously-printed
  /// lines, as the output will change based on any previous entries.
  var stack: [TreePart]

  /// A tuple for the last ‘depth’ and ‘last’ parameters that are passed in.
  var lastParams: TreeParams?
}

public struct TreeParams {

  /// How many directories deep into the tree structure this is. Directories
  /// on top have depth 0.
  let depth: TreeDepth

  /// Whether this is the last entry in the directory.
  public let isLast: Bool

  public init(depth: TreeDepth, isLast: Bool) {
    self.depth = depth
    self.isLast = isLast
  }

  public var isAtRoot: Bool {
    depth.rawValue == 0
  }
}

public struct TreeDepth: RawRepresentable, ExpressibleByIntegerLiteral {
  public var rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  public init(integerLiteral value: Int) {
    self.rawValue = value
  }

  public static var root: Self { .init(rawValue: 0) }
  public var deeper: Self { .init(rawValue: rawValue + 1) }

  public func iterateOver<T: Collection>(_ inner: T) -> Iterator<T> {
    .init(currentDepth: self, inner: inner)
  }

  public struct Iterator<T: Collection>: Sequence, IteratorProtocol {
    init(currentDepth: TreeDepth, inner: T) {
      self.currentDepth = currentDepth
      self.inner = inner
      self.currentIndex = inner.startIndex
    }

    private let currentDepth: TreeDepth
    private let inner: T
    private var currentIndex: T.Index
    public mutating func next() -> (TreeParams, T.Element)? {
      if currentIndex == inner.endIndex {
        return nil
      }
      let t = inner[currentIndex]
      inner.formIndex(after: &currentIndex)
      let params = TreeParams(depth: currentDepth, isLast: currentIndex == inner.endIndex)
      return (params, t)
    }
  }
}

extension TreeTrunk {
  /// Calculates the tree parts for an entry at the given depth and
  /// last-ness. The depth is used to determine where in the stack the tree
  /// part should be inserted, and the last-ness is used to determine which
  /// type of tree part to insert.
  ///
  /// This takes a `&mut self` because the results of each file are stored
  /// and used in future rows.
  public mutating func newRow(params: TreeParams) -> ArraySlice<TreePart> {

    // If this isn’t our first iteration, then update the tree parts thus
    // far to account for there being another row after it.
    if let lastParams {
      self.stack[lastParams.depth.rawValue] = lastParams.isLast ? .blank : .line
    }

    // Make sure the stack has enough space, then add or modify another
    // part into it.
    self.stack.resize(newLength: params.depth.rawValue + 1, value: .edge)

    self.stack[params.depth.rawValue] = params.isLast ? .corner : .edge

    self.lastParams = params

    // Return the tree parts as a slice of the stack.
    //
    // Ignore the first element here to prevent a ‘zeroth level’ from
    // appearing before the very first directory. This level would
    // join unrelated directories without connecting to anything:
    //
    //     with [0..]        with [1..]
    //     ==========        ==========
    //      ├── folder        folder
    //      │  └── file       └── file
    //      └── folder        folder
    //         └── file       └──file
    //
    return self.stack.dropFirst()
  }
}

extension Array {
  mutating func resize(newLength: Int, value: Element) {
    let diff = newLength - count
    if diff > 0 {
      append(contentsOf: repeatElement(value, count: diff))
    } else if diff < 0 {
      removeLast(-diff)
    }
  }
}
