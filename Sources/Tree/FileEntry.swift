public struct FileEntry {
  internal init(name: String, depth: TreeDepth) {
    self.name = name
    self.depth = depth
  }

  public init(rootName: String) {
    self.name = rootName
    self.depth = .root
  }

  public let name: String
  public let depth: TreeDepth

  public private(set) var children: [Self] = []

  mutating func insert(name: String) -> Int {
    let child = Self(name: name, depth: depth.deeper)
    if children.isEmpty {
      children.append(child)
      return 0
    } else {
      if let index = children.firstIndex(where: { $0.name == name }) {
        return index
      } else {
        children.append(child)
        return children.count-1
      }
    }
  }

  public mutating func append(path: String) {
    append(pathComponents: path.split(separator: "/"))
  }

  public mutating func append(pathComponents parts: some Collection<Substring>) {
    assert(!parts.isEmpty)

    let newIndex = insert(name: String(parts[parts.startIndex]))
    if parts.count > 1 {
      children[newIndex].append(pathComponents: parts.dropFirst())
    }
  }

  public func iterate(_ body: (Self, _ isLast: Bool) -> Void) {
    iterate(isLast: false, body)
  }

  func iterate(isLast: Bool, _ body: (Self, _ isLast: Bool) -> Void) {
    body(self, isLast)
    children.dropLast().forEach { $0.iterate(isLast: false, body) }
    children.last.map { $0.iterate(isLast: true, body) }
  }
}

