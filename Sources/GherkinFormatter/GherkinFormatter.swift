// ------------------------------------------------------------------------
// Copyright 2017 Dan Waltin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ------------------------------------------------------------------------
//
//  GherkinFormatter.swift
//  GherkinFormatter
//
//  Created by Dan Waltin on 2017-07-02.
//
// ------------------------------------------------------------------------

import Foundation

public struct GherkinFormatter {

	let columnSeparator = "|"
	
	public init() {
		
	}
	
	public func tableLines(atIndex lineIndex: Int, fromLines lines: [String]) -> [Int] {
		if lineIndex >= lines.count || lineIndex < 0 {
			return []
		}
		
		
		if !isTableLine(lines[lineIndex]) {
			return []
		}

		var tableLineIndices = [Int]()
		// first, check lines above
		if lineIndex > 0 {
			var i = lineIndex - 1
			while i >= 0 {
				if !isTableLine(lines[i]) {
					break
				}
				tableLineIndices.append(i)
				i -= 1
			}
		}
		
		// then check lineIndex and below
		for i in lineIndex..<lines.count {
			if !isTableLine(lines[i]) {
				break
			}
			tableLineIndices.append(i)
		}
		
		tableLineIndices.sort()
		return tableLineIndices
	}
	
	public func formatTable(_ lines: [String]) -> [String] {
		if lines.count == 0 {
			return lines
		}

		let tableLineIndices = self.tableLineIndices(lines)
		if tableLineIndices.count == 0 {
			return lines
		}
		
		let tableLines = tableLineIndices.map{lines[$0]}
		
		let columnWidths = self.columnWidths(tableLines)
		let indentation = rowIndentation(tableLines.first!)
		
		var formattedTableLines = tableLines.map { formattedLine(
			original: $0,
			indentation:  indentation,
			columnWidths: columnWidths)}
		
		if formattedTableLines.count == lines.count {
			return formattedTableLines
		}
		
		for i in formattedTableLines.count..<lines.count {
			formattedTableLines.append(lines[i])
		}
		
		return formattedTableLines
	}

	private func tableLineIndices(_ lines: [String]) -> [Int] {

		var indices = [Int]()
	
		for i in 0..<lines.count {
		
			if !isTableLine(lines[i]) {
				break
			}
			indices.append(i)
		}
		
		return indices
	}

	
	private func isTableLine(_ line: String) -> Bool {
		let trimmed = line.trim()
		if trimmed == "" {
			return false
		}

		let beginsWithColumnSeparator = trimmed.prefix(upTo: trimmed.index(trimmed.startIndex, offsetBy:1)) == columnSeparator
		let endsWithColumnSeparator = trimmed[trimmed.index(trimmed.endIndex, offsetBy:-1)..<trimmed.endIndex] == columnSeparator

		return beginsWithColumnSeparator && endsWithColumnSeparator
	}
	
	private func formattedLine(original: String, indentation: String, columnWidths: [Int: Int]) -> String {
		let cellValues = cellValuesFor(row: original)
		let formattedCellValues = cellValues.enumerated().map{ formattedCellValue(original: $1, col: $0, columnWidths: columnWidths)}

		let start = indentation + columnSeparator
		return formattedCellValues.reduce(start) { x, y in  "\(x) \(y) \(columnSeparator)"}
	}
	
	private func formattedCellValue(original: String, col: Int, columnWidths: [Int: Int]) -> String {
		if col >= columnWidths.count {
			return original
		}
		
		let length = original.count
		
		let space = length < columnWidths[col]! ? String(repeating: " ", count: columnWidths[col]! - length) : ""
		
		return "\(original)\(space)"
	}
	
	// if line == "| hello |", return ""
	// if line == "  | hello |", return "  "
	//
	private func rowIndentation(_ line: String) -> String {
		let substring = line.prefix(upTo: line.index(of: columnSeparator)!)
		return String(describing: substring)
	}
	
 	private func columnWidths(_ lines: [String]) -> [Int: Int] {
		var columnMaxLengths = [Int: Int]()
		
		for row in 0..<lines.count {
			let cellLengths = cellLengthsFor(row: lines[row])
			
			for col in 0..<cellLengths.count {
				if row == 0 {
					columnMaxLengths[col] = cellLengths[col]
				} else {
					if col < columnMaxLengths.count && cellLengths[col] > columnMaxLengths[col]! {
						columnMaxLengths[col] = cellLengths[col]
					}
				}
			}
		}

		return columnMaxLengths
	}
	
	private func cellLengthsFor(row: String) -> [Int] {
		let values = cellValuesFor(row: row)
		
		return values.map{ $0.count}
	}
	
	private func cellValuesFor(row: String) -> [String] {
		// row is in format "| x | y | z | ab c |"
		
		var values = row.trim().asNSString().components(separatedBy: columnSeparator).map{$0.trim()}
		values.remove(at: 0)
		values.remove(at: values.count-1)
		
		return values
	}
}

extension String {
	func replace(_ text: String, with replace: String) -> String {
		return self.asNSString().replacingOccurrences(of: text, with: replace)
	}
	
	func trim() -> String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
	}

	func asNSString() -> NSString {
		return NSString(string: self)
	}
}

extension String {
	func index(of string: String, options: CompareOptions = .literal) -> Index? {
		return range(of: string, options: options)?.lowerBound
	}
}


