# AutoConformingCodableProtocol

Convenience tool for a struct conforming Codable protocol

⚠️ Now only Conforming Decodable Protocol is developed, Conforming Encodable Protocol is in progress

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

# Tutorial
1. Excute `git clone https://github.com/Eric-HanGyeongSoo/AutoConformingCodableProtocol.git` in commandLine
2. Open `AutoConformingCodableProtocol.xcodeproj` with Xcode
3. Enable target signing for both the Application and the Source Code Extension using your own developer ID
4. Select the application target and then Product > Archive
5. Right click Archive > Show in Finder
6. Right click Archive in Finder and Show Package Contents
7. Drag `Products > Applications > AutoConformingCodableProtocol.app` to your Applications folder
8. Exit Xcode
9. Run Swift Initializer Generator.app and exit again.
10. Go to System Preferences -> Extensions -> Xcode Source Editor and enable the extension
11. Run Xcode
12. The menu-item should now be available from Xcode's Editor menu.
