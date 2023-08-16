import Foundation
import Tree

CommandLine.arguments.dropFirst().forEach { path in
  do {
    let contents = try FileManager.default.subpathsOfDirectory(atPath: path)

    var entry = FileEntry(rootName: path)
    for content in contents {
      entry.append(path: content)
    }

    var tt = TreeTrunk(stack: [])
    entry.iterate { item, isLast in
      print(tt.newRow(params: .init(depth: item.depth, isLast: isLast)).map(\.asciiArt).joined(), item.name)
    }
    print()
  } catch {
    print("FAILED opening \(path): \(error.localizedDescription)")
  }
}
