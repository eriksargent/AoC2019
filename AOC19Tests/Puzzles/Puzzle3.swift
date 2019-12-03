//
//  Puzzle3.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle3: PuzzleTestCase {
	override var day: Int { 3 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "R8,U5,L5,D3\nU7,R6,D4,L4", returns: "6")
		assertSolution(for: "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", returns: "159")
		assertSolution(for: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7", returns: "135")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: "R8,U5,L5,D3\nU7,R6,D4,L4", returns: "30")
		assertSolution(for: "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83", returns: "610")
		assertSolution(for: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7", returns: "410")
	}
}
