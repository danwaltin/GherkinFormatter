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
//  NonTableRowsTests.swift
//  GherkinFormatter
//
//  Created by Dan Waltin on 2017-07-04.
//
// ------------------------------------------------------------------------


class NonTableRowsTests : FormattingTestsBase {
	func test_oneLine_withoutLeadingTableIdentifier() {
		when_formattingTable([
			" non table line |"])
		
		then_shouldReturn([
			" non table line |"])
	}

	func test_oneLine_withoutTrailingTableIdentifier() {
		when_formattingTable([
			"| non table line"])
		
		then_shouldReturn([
			"| non table line"])
	}

	func test_oneLine_withoutAnyTableIdentifiers() {
		when_formattingTable([
			" non table line"])
		
		then_shouldReturn([
			" non table line"])
	}

	func test_oneLine_onlyTableIdentifiersInMiddle() {
		when_formattingTable([
			" non | table | line"])
		
		then_shouldReturn([
			" non | table | line"])
	}

	func test_fourRows_whenFirstRowIsNotTable_shouldNotFormat() {
		when_formattingTable([
			" non table row",
			"|h1|h2|",
			"|   r1c1|r1c2|",
			"|r2c1|   r2c2|"])
		
		then_shouldReturn([
			" non table row",
			"|h1|h2|",
			"|   r1c1|r1c2|",
			"|r2c1|   r2c2|"])
	}

	func test_fourRows_whenSecondRowIsNotTable_shouldFormatFirst() {
		when_formattingTable([
			"|h1|h2|",
			" non table row",
			"|   r1c1|r1c2|",
			"|r2c1|   r2c2|"])
		
		then_shouldReturn([
			"| h1 | h2 |",
			" non table row",
			"|   r1c1|r1c2|",
			"|r2c1|   r2c2|"])
	}

	func test_fourRows_whenThirdRowIsNotTable_shouldFormatFirstTwo() {
		when_formattingTable([
			"|h1|h2|",
			"|   r1c1|r1c2|",
			" non table row",
			"|r2c1|   r2c2|"])
		
		then_shouldReturn([
			"| h1   | h2   |",
			"| r1c1 | r1c2 |",
			" non table row",
			"|r2c1|   r2c2|"])
	}

	func test_fourRows_whenThirdRowIsEmpty_shouldFormatFirstTwo() {
		when_formattingTable([
			"|h1|h2|",
			"|   r1c1|r1c2|",
			"",
			"|r2c1|   r2c2|"])
		
		then_shouldReturn([
			"| h1   | h2   |",
			"| r1c1 | r1c2 |",
			"",
			"|r2c1|   r2c2|"])
	}

	func test_fourRows_whenThirdRowIsWhitespace_shouldFormatFirstTwo() {
		when_formattingTable([
			"|h1|h2|",
			"|   r1c1|r1c2|",
			"  ",
			"|r2c1|   r2c2|"])
		
		then_shouldReturn([
			"| h1   | h2   |",
			"| r1c1 | r1c2 |",
			"  ",
			"|r2c1|   r2c2|"])
	}

	func test_fourRows_whenFourthRowIsNotTable_shouldFormatFirstThree() {
		when_formattingTable([
			"|h1|h2|",
			"|   r1c1|r1c2|",
			"|r2c1|   r2c2|",
			" non table row"])
		
		then_shouldReturn([
			"| h1   | h2   |",
			"| r1c1 | r1c2 |",
			"| r2c1 | r2c2 |",
			" non table row"])
	}
}
