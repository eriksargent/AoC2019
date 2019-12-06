//
//  Puzzle6.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/6/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle6: PuzzleTestCase {
	override var day: Int { 6 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L", returns: "42")
		assertSolution(for: "B)C C)D D)E E)F COM)B B)G G)H D)I E)J J)K K)L", returns: "42")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: "COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L K)YOU I)SAN", returns: "4")
	}
}
