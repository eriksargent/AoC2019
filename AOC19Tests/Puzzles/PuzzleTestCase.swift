//
//  PuzzleTestCase.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/2/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class PuzzleTestCase: XCTestCase {
	/// Override the day to set which day to test
	var day: Int { 1 }
	var puzzle: Puzzle.Type?
	
	// MARK: - Puzzle tests
	func testPuzzle1() {
		let daysPuzzles = Puzzles.puzzles.filter({ $0.day == day })
		puzzle = daysPuzzles.first(where: { $0.puzzle == 1 })
		
		XCTAssertNotNil(puzzle, "Puzzle 1 for day \(day) not found")
		if let puzzle = puzzle {
			testPuzzle1(puzzle: puzzle)
		}
	}

	func testPuzzle2() {
		let daysPuzzles = Puzzles.puzzles.filter({ $0.day == day })
		puzzle = daysPuzzles.first(where: { $0.puzzle == 2 })
		
		XCTAssertNotNil(puzzle, "Puzzle 2 for day \(day) not found")
		if let puzzle = puzzle {
			testPuzzle2(puzzle: puzzle)
		}
	}
	
	/// Override and add tests for the first puzzle
	func testPuzzle1(puzzle: Puzzle.Type) {
		
	}
	
	/// Override and add tests for the first puzzle
	func testPuzzle2(puzzle: Puzzle.Type) {
		
	}
	
	
	// MARK: - Test cases
	func assertSolution(for input: String, returns: String, file: StaticString = #file, line: UInt = #line) {
		XCTAssertNotNil(puzzle, file: file, line: line)
		
		if let puzzle = puzzle {
			XCTAssertEqual(puzzle.solve(input: input), returns, file: file, line: line)
		}
	}
}


// MARK: - Template
/*
import XCTest

@testable import AOC19


class Puzzle<#day#>: PuzzleTestCase {
	override var day: Int { <#day#> }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
//		assertSolution(for: <#input#>, returns: <#output#>)
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
//		assertSolution(for: <#input#>, returns: <#output#>)
	}
}
*/
