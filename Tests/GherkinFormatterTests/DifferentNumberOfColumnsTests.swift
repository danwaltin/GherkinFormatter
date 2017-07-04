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
//  DifferentNumberOfColumnsTests.swift
//  GherkinFormatter
//
//  Created by Dan Waltin on 2017-07-04.
//
// ------------------------------------------------------------------------


class DifferentNumberOfColumnsTests : FormattingTestsBase {
	func test_headerOneColumn_rowTwoColumns() {
		when_formattingTable([
			"| header |",
			"| one | two |"])
		
		then_shouldReturn([
			"| header |",
			"| one    | two |"])
	}

	func test_headerOneColumn_rowsTwoColumnsDifferentWidths() {
		when_formattingTable([
			"| header |",
			"| one | two |",
			"| three | four |"])
		
		then_shouldReturn([
			"| header |",
			"| one    | two |",
			"| three  | four |"])
	}

	func test_headerTwoColumns_rowOneColumn() {
		when_formattingTable([
			"| one | two |",
			"| row |"])
		
		then_shouldReturn([
			"| one | two |",
			"| row |"])
	}

	func test_headerTwoColumns_rowOneAndThreeColumns() {
		when_formattingTable([
			"| header one | header two |",
			"| r11 |",
			"| r21 | r22 |r23 |"])
		
		then_shouldReturn([
			"| header one | header two |",
			"| r11        |",
			"| r21        | r22        | r23 |"])
	}
}
