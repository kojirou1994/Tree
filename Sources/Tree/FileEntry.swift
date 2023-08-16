public struct FileEntry<Info> {
  internal init(name: String, depth: TreeDepth, info: Info?) {
    self.name = name
    self.depth = depth
    self.info = info
  }

  public init(rootName: String, info: Info? = ()) {
    self.name = rootName
    self.depth = .root
    self.info = info
  }

  public let name: String
  public let depth: TreeDepth
  public let info: Info?

  public private(set) var children: [Self] = []

  mutating func insert(name: String, info: Info?) -> Int {
    if let index = children.firstIndex(where: { $0.name == name }) {
      return index
    } else {
      let child = Self(name: name, depth: depth.deeper, info: info)
      children.append(child)
      return children.count-1
    }
  }

  public mutating func append(path: String, info: Info? = ()) {
    append(pathComponents: path.split(separator: "/"), info: info)
  }

  public mutating func append(pathComponents parts: some Collection<Substring>, info: Info? = ()) {
    assert(!parts.isEmpty)

    let newIndex = insert(name: String(parts[parts.startIndex]), info: parts.count == 1 ? info : nil)
    if parts.count > 1 {
      children[newIndex].append(pathComponents: parts.dropFirst(), info: info)
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

