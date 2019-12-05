//
//  Puzzle4.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/4/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle4: PuzzleTestCase {
	override var day: Int { 4 }
	
	func testRangeParse() {
		XCTAssertEqual(Puzzle4_1.parseRange(input: ""), 0...0)
		XCTAssertEqual(Puzzle4_1.parseRange(input: "4-10"), 4...10)
	}
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "100000-111113", returns: "3")
		assertSolution(for: "123456-123458", returns: "0")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: "100000-111113", returns: "0")
		assertSolution(for: "100000-111122", returns: "1")
		assertSolution(for: "111222-111222", returns: "0")
		assertSolution(for: "123456-123458", returns: "0")
		assertSolution(for: "123455-123458", returns: "1")
		assertSolution(for: "111230-111233", returns: "1")
	}
}
