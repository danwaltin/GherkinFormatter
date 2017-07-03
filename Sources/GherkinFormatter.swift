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

	public init() {
		
	}
	
	public func formatTable(_ lines: [String]) -> [String] {
		if lines.count == 0 {
			return lines
		}
		
		var newLines = [String]()

		var maxLength = 0
		for line in lines {
			let lineValue = line.replace("|", with: "").trim()
			let length = lineValue.characters.count

			if length > maxLength {
				maxLength = length
			}
		}
		
		for line in lines {
			let lineValue = line.replace("|", with: "").trim()
			let length = lineValue.characters.count
			
			if length < maxLength {
				let space = String(repeating: " ", count: maxLength - length)
				newLines.append("| \(lineValue)\(space) |")
			} else {
				newLines.append("| \(lineValue) |")
			}
		}
		return newLines
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

