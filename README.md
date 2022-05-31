# AutoConformingCodableProtocol

convenience tool for a struct conforming Codable protocol

# Decodable

## Example
```Swift
struct Example: Decodable {
	let id: Int
	let name: String
	let isGood: Bool
}
```

Drag and select from `let id: Int` to `let isGood: Bool`

Then Editor > SourceEditorExtension > SourceEditorCommand

```Swift
struct Example: Decodable {
  let id: Int
  let name: String
  let isGood: Bool

  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case isGood
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.isGood = try container.decode(Bool.self, forKey: .isGood)
  }
}
```
