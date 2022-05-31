//
//  Generator.swift
//  SourceEditorExtension
//
//  Created by 한경수 on 2022/05/31.
//

import Foundation

enum Generator {
  static func generate(selection: [String], indentation: String, leadingIndent: String) -> [String] {
    let variables = VariablesGenerator.generate(from: selection)
    guard !variables.isEmpty else { return [] }
    let generatedCodingKeys = generateCodingKeys(variables.map(caseArgument), indentation)
    let generatedInit = generateInit(variables.map(argument), indentation)
    let lines = (generatedCodingKeys + [""] + generatedInit).map { "\(leadingIndent)\($0)" }
    
    return lines
  }
  
  private static func expression(variable: Variable, indentation: String) -> String {
    
    if variable.name.first == "_" {
      var name = variable.name
      name.removeFirst()
      return "\(indentation)\(variable.name) = \(name)"
    }
    
    return "\(indentation)self.\(variable.name) = \(variable.name)"
  }
  
  private static func argument(variable: Variable) -> String {
    return "self.\(variable.name) = try container.decode(\(variable.type).self, forKey: .\(variable.name))"
  }
  
  private static func caseArgument(variable: Variable) -> String {
    return "case \(variable.name)"
  }
  
  private static func generateCodingKeys(_ arguments: [String], _ indentation: String) -> [String] {
    var result: [String] = ["private enum CodingKeys: String, CodingKey {"]
    
    arguments.forEach { argument in
      result.append(indentation + argument)
    }
    
    result.append("}")
    
    return result
  }
  
  private static func generateInit(_ arguments: [String], _ indentation: String) -> [String] {
    var result: [String] = ["init(from decoder: Decoder) throws {"]
    result.append(indentation + "let container = try decoder.container(keyedBy: CodingKeys.self)")
    
    arguments.forEach { argument in
      result.append(indentation + argument)
    }
    
    result.append("}")
    
    return result
  }
}

private enum VariablesGenerator {
  static func generate(from selection: [String]) -> [Variable] {
    return selection
      .multiLineCommentsRemoved
      .map(removeSingleLineComment)
      .map(removeNewLineSymbol)
      .map { $0.split(separator: " ") }
      .map(removeAllTypePrefixes)
      .map(convertPrepreparedArrayToVariable)
      .compactMap { $0 }
  }
  
  private static func removeSingleLineComment(for string: String) -> String {
    var mutable = string
    if let startOfComments = mutable.range(of: "//") {
      mutable.removeSubrange(startOfComments.lowerBound..<mutable.endIndex)
    }
    return mutable
  }
  
  private static func removeNewLineSymbol(for string: String) -> String {
    var mutable = string
    if let newLineSymbolPosition = mutable.range(of: "\n") {
      mutable.removeSubrange(newLineSymbolPosition)
    }
    return mutable
  }
  
  private static func removeAllTypePrefixes(for array: [Substring]) -> [Substring] {
    var mutable = array
    guard let mutabilityIdentifierIndex = mutable.firstIndex(where: { $0.contains("var") || $0.contains("let") }) else { return [] }
    if mutabilityIdentifierIndex == mutable.startIndex { return mutable }
    mutable.removeSubrange(mutable.startIndex..<mutabilityIdentifierIndex)
    return mutable
  }
  
  private static func convertPrepreparedArrayToVariable(_ array: [Substring]) -> Variable? {
    guard array.count >= 3 else { return nil }
    var line = array.map(String.init)
    _ = line.removeFirst()
    var name = line.removeFirst()
    name.removeAll { $0 == ":" }
    let type = line.joined(separator: " ")
    return Variable(name: name, type: type)
  }
}

private extension Array where Element == String {
  var multiLineCommentsRemoved: [String] {
    var selection = self
    if let openCommentIndex = selection.firstIndex(where: { $0.contains("/*") }), openCommentIndex != selection.endIndex {
      let closeCommentIndex = selection.firstIndex { $0.contains("*/") } ?? selection.endIndex
      selection.removeSubrange(openCommentIndex...closeCommentIndex)
    }
    if selection.contains(where: { $0.contains("/*") || $0.contains("*/") }) {
      selection = selection.multiLineCommentsRemoved
    }
    
    return selection
  }
}
