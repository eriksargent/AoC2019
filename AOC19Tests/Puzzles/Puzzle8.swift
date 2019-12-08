//
//  Puzzle8.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/8/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle8: PuzzleTestCase {
	override var day: Int { 8 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "123456789012;3;2", returns: "1")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: "0222112222120000;2;2", returns: "◼︎◻︎\n◻︎◼︎")
		assertSolution(for: "02022222111122222222121200000000;4;2", returns: "◼︎◻︎◼︎◻︎\n◻︎◼︎◻︎◼︎")
	}
}
