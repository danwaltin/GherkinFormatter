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
	
	public func formatTable(_ lines: [String]) -> [String] {
		if lines.count == 0 {
			return lines
		}
		
		let columnWidths = self.columnWidths(lines)
		
		return lines.map { formattedLine(
			original: $0,
			columnWidths: columnWidths)}
	}

	private func formattedLine(original: String, columnWidths: [Int: Int]) -> String {
		let cellValues = cellValuesFor(row: original)
		let formattedCellValues = cellValues.enumerated().map{ formattedCellValue(original: $1, col: $0, columnWidths: columnWidths)}

		return formattedCellValues.reduce(columnSeparator) { x, y in  "\(x) \(y) \(columnSeparator)"}
	}
	
	private func formattedCellValue(original: String, col: Int, columnWidths: [Int: Int]) -> String {
		let length = original.characters.count
		
		let space = length < columnWidths[col]! ? String(repeating: " ", count: columnWidths[col]! - length) : ""
		
		return "\(original)\(space)"
	}
	
 	private func columnWidths(_ lines: [String]) -> [Int: Int] {
		var columnMaxLengths = [Int: Int]()
		
		var row = 0
		for line in lines {
			let cellLengths = cellLengthsFor(row: line)
			
			for col in 0..<cellLengths.count {
				if row == 0 {
					columnMaxLengths[col] = cellLengths[col]
				} else {
					if cellLengths[col] > columnMaxLengths[col]! {
						columnMaxLengths[col] = cellLengths[col]
					}
				}
			}
			
			row += 1
		}

		return columnMaxLengths
	}
	
	private func cellLengthsFor(row: String) -> [Int] {
		let values = cellValuesFor(row: row)
		
		return values.map{ $0.characters.count}
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

