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
//  TableLinesTests.swift
//  GherkinFormatter
//
//  Created by Dan Waltin on 2017-07-05.
//
// ------------------------------------------------------------------------

import XCTest
@testable import GherkinFormatter

class TableLinesTests : XCTestCase {
	
	// MARK: - Zero case
	func test_zeroLines_index0_shouldReturnEmpty() {
		when_getTableLines(
			0, [])
		
		then_shouldReturn(
			[])
	}

	func test_zeroLines_index1_shouldReturnEmpty() {
		when_getTableLines(
			1, [])
		
		then_shouldReturn(
			[])
	}

	func test_oneTableLine_index1_shouldReturnEmpty() {
		when_getTableLines(
			1, ["| header |"])
		
		then_shouldReturn(
			[])
	}

	func test_oneTableLine_indexMinus1_shouldReturnEmpty() {
		when_getTableLines(
			-1, ["| header |"])
		
		then_shouldReturn(
			[])
	}

	// MARK: - Only table lines in input
	func test_oneTableLine() {
		given_lines(
			["| header |"])

		when_getTableLines(forIndex: 0)
		then_shouldReturn([0])
	}

	func test_twoTableLines() {
		given_lines(
			["| header |",
			 "| row |"])

		when_getTableLines(forIndex: 0)
		then_shouldReturn([0, 1])

		when_getTableLines(forIndex: 1)
		then_shouldReturn([0, 1])
	}

	func test_threeTableLines() {
		given_lines(
			["| header |",
			 "| row one|",
			 "| row two|"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([0, 1, 2])

		when_getTableLines(forIndex: 1)
		then_shouldReturn([0, 1, 2])

		when_getTableLines(forIndex: 2)
		then_shouldReturn([0, 1, 2])
	}

	// MARK: - Non-table lines in input
	// MARK: One line
	func test_oneNonTableLine() {
		given_lines(
			[" non table line"])
		
		when_getTableLines(forIndex: 0)

		then_shouldReturn([])
	}

	// MARK: Two lines
	func test_twoLinesNonTable() {
		given_lines(
			[" non table line",
			 " non table line"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([])

		when_getTableLines(forIndex: 1)
		then_shouldReturn([])
	}

	func test_twoLinesFirstNonTable() {
		given_lines(
			[" non table line",
			 " | table line |"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([])

		when_getTableLines(forIndex: 1)
		then_shouldReturn([1])
	}

	func test_twoLinesSecondNonTable() {
		given_lines(
			[" | table line |",
			 " non table line"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([0])
		
		when_getTableLines(forIndex: 1)
		then_shouldReturn([])
	}
	
	// MARK: Three lines
	func test_threeLinesNonTable() {
		given_lines(
			[" non table line",
			 " non table line",
			 " non table line"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([])

		when_getTableLines(forIndex: 1)
		then_shouldReturn([])
		
		when_getTableLines(forIndex: 2)
		then_shouldReturn([])
	}

	func test_threeLinesFirstAndSecondNonTable() {
		given_lines(
			[" non table line",
			 " non table line",
			 " | table line |"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([])
		
		when_getTableLines(forIndex: 1)
		then_shouldReturn([])
		
		when_getTableLines(forIndex: 2)
		then_shouldReturn([2])
	}

	func test_threeLinesFirstAndThirdNonTable() {
		given_lines(
			[" non table line",
			 " | table line |",
			 " non table line"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([])
		
		when_getTableLines(forIndex: 1)
		then_shouldReturn([1])
		
		when_getTableLines(forIndex: 2)
		then_shouldReturn([])
	}
	
	func test_threeLinesSecondAndThirdNonTable() {
		given_lines(
			[" | table line |",
			 " non table line",
			 " non table line"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([0])
		
		when_getTableLines(forIndex: 1)
		then_shouldReturn([])
		
		when_getTableLines(forIndex: 2)
		then_shouldReturn([])
	}
	

	func test_threeLinesFirstNonTable() {
		given_lines(
			[" non table line",
			 " | table line |",
			 " | table line |"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([])
		
		when_getTableLines(forIndex: 1)
		then_shouldReturn([1, 2])
		
		when_getTableLines(forIndex: 2)
		then_shouldReturn([1, 2])
	}
	
	func test_threeLinesSecondNonTable() {
		given_lines(
			[" | table line |",
			 " non table line",
			 " | table line |"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([0])
		
		when_getTableLines(forIndex: 1)
		then_shouldReturn([])
		
		when_getTableLines(forIndex: 2)
		then_shouldReturn([2])
	}

	func test_threeLinesThirdNonTable() {
		given_lines(
			[" | table line |",
			 " | table line |",
			 " non table line"])
		
		when_getTableLines(forIndex: 0)
		then_shouldReturn([0, 1])
		
		when_getTableLines(forIndex: 1)
		then_shouldReturn([0, 1])
		
		when_getTableLines(forIndex: 2)
		then_shouldReturn([])
	}
	
	// MARK: - Helpers
	
	var actualLineIndices = [Int]()
	var lines = [String]()
	
	private func given_lines(_ lines: [String]) {
		self.lines = lines
	}

	private func when_getTableLines(forIndex index: Int) {
		when_getTableLines(index, lines)
	}

	private func when_getTableLines(_ index: Int, _ lines: [String]) {
		let formatter = GherkinFormatter()
		
		actualLineIndices = formatter.tableLines(atIndex: index, fromLines: lines)
	}

	private func then_shouldReturn(_ expected: [Int]) {
		XCTAssertEqual(actualLineIndices, expected)
	}
}
