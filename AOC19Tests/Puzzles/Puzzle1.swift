//
//  Puzzle1.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/2/19.
//  Copyright © 2018 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle1: PuzzleTestCase {
	override var day: Int { 1 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "12", returns: "2")
		assertSolution(for: "14", returns: "2")
		assertSolution(for: "1969", returns: "654")
		assertSolution(for: "100756", returns: "33583")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: "14", returns: "2")
		assertSolution(for: "1969", returns: "966")
		assertSolution(for: "100756", returns: "50346")
	}
}
