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
//  FormatTableTests.swift
//  GherkinFormatter
//
//  Created by Dan Waltin on 2017-07-02.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinFormatter

class FormatTableTests: XCTestCase {
	
	private var actualFormattedText = [String]()
	
	func test_emptyString_shouldReturnEmptyString() {
		when_formattingTable([])
		
		then_shouldReturn([])
    }
	
	// MARK:- one column
	
	func test_oneColumn_onlyHeaderRow() {
		when_formattingTable([
			"| header |"])
		
		then_shouldReturn([
			"| header |"])
	}

	func test_oneColumnOneRow_alreadyFormatted() {
		when_formattingTable([
			"| header |",
			"| row    |"])
		
		then_shouldReturn([
			"| header |",
			"| row    |"])
	}

	func test_oneColumnOneRow_rowShorterThanHeader() {
		when_formattingTable([
			"|header|",
			"|row|"])
		
		then_shouldReturn([
			"| header |",
			"| row    |"])
	}

	func test_oneColumnTwoRows_lastRowLongerThanHeader() {
		when_formattingTable([
			"| header value |",
			"| row value |",
			"| second row value |"])
		
		then_shouldReturn([
			"| header value     |",
			"| row value        |",
			"| second row value |"])
	}

	// MARK:- two columns

	func test_twoColumnsTwoRows_equalLengths() {
		when_formattingTable([
			"| equal|equal |",
			"|equal | equal|"])
		
		then_shouldReturn([
			"| equal | equal |",
			"| equal | equal |"])
	}

	// MARK:- three columns

	func test_threeColumns_twoRows() {
		when_formattingTable([
			"| header 1 | header 2 |h3 longest |",
			"| r1c1| r1c2| r1c3|",
			"|r2c1|r2c2 longest|r2c3|",
			"|r3c1 longest |r3c2|r3c3|"])
		
		then_shouldReturn([
			"| header 1     | header 2     | h3 longest |",
			"| r1c1         | r1c2         | r1c3       |",
			"| r2c1         | r2c2 longest | r2c3       |",
			"| r3c1 longest | r3c2         | r3c3       |"])
	}

	// MARK:- indentation

	func _test_oneColumnOneRow_rowIndentedWithSpace() {
		when_formattingTable([
			"| header |",
			" | row |"])
		
		then_shouldReturn([
			"| header |",
			"| row    |"])
	}

	func _test_headerIndentedWithOneSpace_shouldKeepIndentation() {
		when_formattingTable([
			" | header |",
			"| row |"])
		
		then_shouldReturn([
			" | header |",
			" | row    |"])
	}

	func _test_headerIndentedWithTwoSpaces_shouldKeepIndentation() {
		when_formattingTable([
			"  | header |",
			"| row |"])
		
		then_shouldReturn([
			"  | header |",
			"  | row    |"])
	}

	func _test_headerIndentedWithOneTab_shouldKeepIndentation() {
		when_formattingTable([
			"\t| header |",
			"| row |"])
		
		then_shouldReturn([
			"\t| header |",
			"\t| row    |"])
	}

	// MARK: - handle different number of columns in the header and rows
	
	// MARK: - helpers
	
	private func when_formattingTable(_ lines: [String]) {
		actualFormattedText = GherkinFormatter().formatTable(lines)
	}
	
	private func then_shouldReturn(_ expected: [String]) {
		XCTAssertEqual(actualFormattedText, expected)
	}
}
